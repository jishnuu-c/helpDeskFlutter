import 'package:flutter/material.dart';
import '../../../services/kb_service.dart';

class KbPage extends StatefulWidget {
  const KbPage({super.key});

  @override
  State<KbPage> createState() => _KbPageState();
}

class _KbPageState extends State<KbPage> {
  final KbService service = KbService();

  List articles = [];
  List filteredArticles = [];
  bool loading = true;

  String searchQuery = '';
  int? selectedCategory;

  final Map<int, String> categoryLabels = {
    1: 'Account',
    2: 'Tickets',
    3: 'Software',
    4: 'Network',
    5: 'Hardware',
  };

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  Future loadArticles() async {
    try {
      articles = await service.getKbArticles();
      filteredArticles = List.from(articles);
    } catch (e) {
      // error
    }
    setState(() => loading = false);
  }

  void applyFilters() {
    setState(() {
      filteredArticles = articles.where((a) {
        final matchSearch = searchQuery.isEmpty
            ? true
            : (a["title"] ?? "").toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  (a["content"] ?? "").toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );

        final matchCategory = selectedCategory == null
            ? true
            : a["categoryId"] == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();
    });
  }

  List<int> get uniqueCategories {
    final ids = articles
        .map((a) => a["categoryId"] as int?)
        .whereType<int>()
        .toSet()
        .toList();
    ids.sort();
    return ids;
  }

  String getCategoryLabel(int id) {
    return categoryLabels[id] ?? 'Category $id';
  }

  String getContentPreview(String content) {
    final plain = content
        .replaceAll(RegExp(r'[#\-*\d\.]'), '')
        .replaceAll(RegExp(r'\n+'), ' ')
        .trim();
    return plain.length > 120 ? '${plain.substring(0, 120)}…' : plain;
  }

  Color getCategoryColor(int id) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),
      body: Column(
        children: [
          // Header + Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Knowledge Base",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Browse articles and guides",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) {
                    searchQuery = v;
                    applyFilters();
                  },
                  decoration: InputDecoration(
                    hintText: "Search articles...",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xfff1f5f9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Category Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // All tab
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = null);
                      applyFilters();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: selectedCategory == null
                            ? Colors.blue
                            : const Color(0xfff1f5f9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "All",
                        style: TextStyle(
                          color: selectedCategory == null
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  // Category tabs
                  ...uniqueCategories.map((cid) {
                    final isSelected = selectedCategory == cid;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = cid);
                        applyFilters();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue
                              : const Color(0xfff1f5f9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getCategoryLabel(cid),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Body
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filteredArticles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No articles found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Try a different search or category",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      final catId = article["categoryId"] ?? 0;
                      final published = article["published"] == true;
                      final tags = article["tags"] as List?;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top row — category + published badge
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getCategoryColor(
                                        catId,
                                      ).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      getCategoryLabel(catId),
                                      style: TextStyle(
                                        color: getCategoryColor(catId),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: published
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      published ? "Published" : "Draft",
                                      style: TextStyle(
                                        color: published
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Title
                              Text(
                                article["title"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Preview
                              Text(
                                getContentPreview(article["content"] ?? ""),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),

                              // Tags
                              if (tags != null && tags.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 6,
                                  children: tags
                                      .map(
                                        (tag) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff1f5f9),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            "#$tag",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],

                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 10),

                              // Footer — author + read button
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    article["author"] ?? "Unknown",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: () {
                                      // Read article — future implementation
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                    ),
                                    label: const Text("Read"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Count footer
          if (!loading && filteredArticles.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Showing ${filteredArticles.length} of ${articles.length} articles",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
