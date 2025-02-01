class Company {
  num company_id;
  num points_earned;
  num monthly_sales;
  num reward_token_value;
  num scaling_constant;
  String created_at;
  String updated_at;
  String image_path;
  String company_type;
  String name;

  Company({
    required this.company_id,
    required this.points_earned,
    required this.monthly_sales,
    required this.reward_token_value,
    required this.scaling_constant,
    required this.created_at,
    required this.updated_at,
    required this.image_path,
    required this.company_type,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      company_id: json['company_id'],
      points_earned: json['points_earned'],
      monthly_sales: json['monthly_sales'],
      reward_token_value: json['reward_token_value'],
      scaling_constant: json['scaling_constant'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      image_path: json['image_path'],
      company_type: json['company_type'],
      name: json['name'],
    );
  }
}
