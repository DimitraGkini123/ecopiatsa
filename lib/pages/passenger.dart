class Passenger {
  static int? loggedInUserId; // Store the logged-in user's ID
  static String? username;
  static String? password;
  static String? email;
  static String? firstName;
  static String? lastName;
  static DateTime? date_of_birth;
  static String? telephone;
  static int? card_number;
  static int? cvv;
  static String? card_name;
  static int? exp_date;
    static void clearLoggedInUserId() {
    loggedInUserId = null;
  }
}