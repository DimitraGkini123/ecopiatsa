class Driver {
  static int? loggedInUserId; // Store the logged-in user's ID
  static String? username;
  static String? password;
  static String? email;
  static String? firstName;
  static String? lastName;
  static DateTime? date_of_birth;
  static String? telephone;
  static String? car_model;
  static int? car_number;
  static String? car_colour;
  static int? car_consumption;
  static int? car_year;
    static void clearLoggedInUserId() {
    loggedInUserId = null;
  }
}