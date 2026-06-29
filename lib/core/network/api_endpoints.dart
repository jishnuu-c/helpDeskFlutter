class ApiEndpoints {
  static const String baseUrl = 'http://192.168.1.110:8080/api/helpdesk';

  // Tickets
  static const String createTicket = '/tickets/create';

  static const String getTickets = '/tickets/get-all-ticket';

  static const String getTicketById = '/tickets/get-ticket';

  // Comments
  static const String commentBase = '/tickets/comment';

  // Departments
  static const String departments = '/department/get-all-department';

  static const String createDepartment = '/department/add-department';

  // Categories
  static const String categories = '/category/get-all-category';

  static const String createCategory = '/category/add-category';

  // SLA
  static const String getSlas = '/sla-policy/get-all-sla';

  static const String createSla = '/sla-policy/add-sla';

  // Users
  static const String users = '/auth/fetch-all';

  static const String getLogs = '/audit/audit-logs';

  static const String agentWorkload = '/admin/agent-workload';

  static const String kbArticles = '/kb/articles';

  static const String fetchStaffs = '/auth/fetch-all-staff';

  static const String updateStatus = '/tickets/status';

  // File URL
  static const String fileBaseUrl = 
  // 'http://192.168.0.20:8080/';
    'http://192.168.1.110:8080/';
}
















