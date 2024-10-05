
import io
import traceback
from flask import Flask, request, jsonify, json, send_file, send_from_directory, session
import pymysql
import secrets
#from flask_socketio import SocketIO
from datetime import datetime
from werkzeug.utils import secure_filename
import os, base64
from flask_cors import CORS
from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user

# Details about base
config1 = {
    "user": "root",
    "password": "1234",
    "host": "localhost",
    "database": "ecopiatsa",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}
config2 = {
    "user": "root",
    "password": "1234",
    "host": "localhost",
    "database": "ecopiatsa",
    "charset": "utf8mb4",
    "cursorclass": pymysql.cursors.DictCursor,
}


app = Flask(__name__)
# we use keys in order to store the user's data in sessions.
app.secret_key = secrets.token_hex(24)
#socketio = SocketIO(app)
CORS(app)

@app.route("/passenger_login", methods=['POST'])
def passenger_login():
    if request.method == 'POST':
        data = request.get_json()

        username = data.get('username')
        password = data.get('password')

        conn = pymysql.connect(**config2)  # Connection with the database

        with conn.cursor() as cursor:
            query = "SELECT * FROM passengers WHERE username = %s AND password = %s"
            cursor.execute(query, (username, password))
            user = cursor.fetchone()
            if user:
                response_data = {
                    "user_id": user['ID'],
                    #"other_user_data": user['other_field'],  # Include other user data if needed
                }
                return jsonify(response_data)
            else:
                return jsonify({"error": "Invalid credentials"}), 401  # Unauthorized

    return jsonify({"error": "Method not allowed"}), 405

@app.route("/passenger_signup", methods = ['GET','POST'])
def passenger_signup():
    data = request.get_json()  # Assuming data is sent as JSON in the request body

    # Extract data from JSON payload
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    telephone = data.get('telephone')
    date_of_birth = data.get('date_of_birth')
    card_name = data.get('card_name')
    card_number = data.get('card_number')
    exp_date = data.get('exp_date')
    cvv= data.get('cvv')
    id_pic= data.get('id')

    
    conn = pymysql.connect(**config2)
    with conn.cursor() as cursor:
        query = "INSERT INTO passengers(first_name,last_name,username,password,email,telephone,date_of_birth,card_name, card_number, exp_date, cvv, id_pic ) VALUES(%s,%s,%s,%s,%s,%s,%s, %s, %s, %s, %s, %s)"
        cursor.execute(query, (first_name, last_name,username,password,email, telephone,date_of_birth, card_name, card_number, exp_date, cvv, id_pic ))
        conn.commit()

        # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
        if cursor.rowcount > 0:
            return jsonify({"message" : "User registered successfully"}),200
        else:
            return jsonify({"message" : "User could not be registered"}),201
        


@app.route("/driver_signup", methods = ['GET','POST'])
def driver_signup():
    data = request.get_json()  # Assuming data is sent as JSON in the request body

    # Extract data from JSON payload
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    telephone = data.get('telephone')
    date_of_birth = data.get('date_of_birth')
    
    car_number = data.get('car_number')
    car_model = data.get('car_model')
    car_colour = data.get('car_colour')
    car_year = data.get('car_year')
    car_consumption = data.get('car_consumption')
    id_pic= data.get('id')
    traffic_license= data.get('traffic_license')
    license = data.get('license')
    print(car_number)
    conn = pymysql.connect(**config2)
    with conn.cursor() as cursor:
        query = "INSERT INTO drivers(first_name,last_name,username,password,email,telephone,date_of_birth, car_number, car_model, car_colour,car_consumption, car_year) VALUES(%s,%s,%s,%s,%s,%s,%s, %s, %s, %s, %s,%s)"
        cursor.execute(query, (first_name, last_name,username,password,email, telephone,date_of_birth, car_number, car_model, car_colour, car_consumption, car_year ))
        conn.commit()

        # If cursor.rowcount is greater than 0, it means that some rows were affected by the INSERT statement.
        if cursor.rowcount > 0:
            return jsonify({"message" : "User registered successfully"}),200
        else:
            return jsonify({"message" : "User could not be registered"}),201
        
@app.route("/driver_login", methods=['POST'])
def driver_login():
    if request.method == 'POST':
        data = request.get_json()

        username = data.get('username')
        password = data.get('password')

        conn = pymysql.connect(**config2)  # Connection with the database

        with conn.cursor() as cursor:
            query = "SELECT * FROM drivers WHERE username = %s AND password = %s"
            cursor.execute(query, (username, password))
            user = cursor.fetchone()
            if user:
                response_data = {
                    "user_id": user['ID'],
                    #"other_user_data": user['other_field'],  # Include other user data if needed
                }
                return jsonify(response_data)
            else:
                return jsonify({"error": "Invalid credentials"}), 401  # Unauthorized

    return jsonify({"error": "Method not allowed"}), 405




# Your existing /card_details route
@app.route("/card_details", methods=['GET'])
def card_details():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT card_name, card_number, cvv, exp_date FROM passengers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

            if result:
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500

@app.route("/view_car_details", methods=['GET'])
def view_car_details():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT car_model, car_number, car_colour, car_consumption, car_year FROM drivers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

            if result:
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        

@app.route("/profile_info", methods=['GET'])
def profile_info():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT * FROM passengers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result:  # Replace 'default_value' with a suitable default
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        
@app.route("/profile_info_driver", methods=['GET'])
def profile_info_driver():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT * FROM drivers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result:  # Replace 'default_value' with a suitable default
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        
        
@app.route("/view_idpic", methods=['GET'])
def view_idpic():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT id_pic FROM passengers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result is not None and result[0] is not None:
                return jsonify(pic=result[0]), 200
            else:
                # Provide a suitable default or handle the case as needed
                return jsonify({'error': 'id_pic not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500

@app.route("/view_idpic_driver", methods=['GET'])
def view_idpic_driver():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = "SELECT id_pic FROM drivers WHERE ID = %s"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result is not None and result[0] is not None:
                return jsonify(pic=result[0]), 200
            else:
                # Provide a suitable default or handle the case as needed
                return jsonify({'error': 'id_pic not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        
@app.route("/update_telephone", methods=['POST'])
def update_telephone():
    if request.method == 'POST':
        try:
            data = request.get_json()
            # Get parameters from the request
            user_id = request.args.get('user_id')
            new_telephone = data.get('new_telephone')

            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Update the telephone in the database
                query = "UPDATE passengers SET telephone = %s WHERE ID = %s"
                cursor.execute(query, (new_telephone, user_id))

            return jsonify({'message': 'Telephone updated successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

        
@app.route("/update_card_details", methods=['POST'])
def update_card_details():
    if request.method == 'POST':
        try:
            data = request.get_json()
            # Get parameters from the request
            user_id = data.get('user_id')
            edited_card_details = data.get('edited_card_details')

            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Update the card details in the database
                query = "UPDATE passengers SET card_name = %s, card_number = %s, cvv = %s, exp_date = %s WHERE ID = %s"
                cursor.execute(query, (
                    edited_card_details.get('card_name'),
                    edited_card_details.get('card_number'),
                    edited_card_details.get('cvv'),
                    edited_card_details.get('exp_date'),
                    user_id,
                ))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Card details updated successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

@app.route("/save_driver_route_now", methods=['POST'])
def save_driver_route_now():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO drivers_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, driver_id, scheduled) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id,0))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Driver route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405

@app.route("/save_driver_route_scheduled", methods=['POST'])
def save_driver_route_scheduled():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO drivers_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, driver_id, scheduled) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id,1))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Driver route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405

@app.route("/save_passenger_route_now", methods=['POST'])
def save_passenger_route_now():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            # Connect to the database
            print("hours:")
            print(hours)
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO passenger_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, passenger_id, scheduled) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id,0))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Passengers route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405

@app.route("/save_passenger_route_scheduled", methods=['POST'])
def save_passenger_route_scheduled():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO passenger_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, passenger_id, scheduled) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id,1))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Passenger route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405

@app.route("/possible_matches", methods=['GET'])
def possible_matches():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            start_area = request.args.get('start_area')
            start_country = request.args.get('start_country')
            end_area = request.args.get('end_area')
            end_country = request.args.get('end_country')
            hours = request.args.get('hours')
            day = request.args.get('day')
            date = request.args.get('date')

            print("date", date)

            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = '''
SELECT DISTINCT
    dr.id AS drivers_route_id,
    pr.id AS passenger_routes_id,
    dr.driver_id AS drivers_id,
    d.first_name AS driver_first_name,
    d.last_name AS driver_last_name,
    dr.start_area AS route_start_area,
    dr.start_country AS route_start_country,
    dr.destination_area AS route_destination_area,
    dr.destination_country AS route_destination_country,
    dr.day AS route_day,
    dr.date AS route_date,
    dr.hours AS route_hours,
    dr.minutes AS route_minutes,
    d.telephone AS driver_phone,
    d.email AS driver_email,
    dr.scheduled AS scheduled
FROM
    passenger_routes AS pr
JOIN
    drivers_routes AS dr ON pr.start_area = dr.start_area
    AND pr.start_country = dr.start_country
    AND pr.destination_area = dr.destination_area
    AND pr.destination_country = dr.destination_country
    AND pr.hours = dr.hours
    AND (
        (dr.scheduled = 0 AND pr.day = dr.day AND pr.date = dr.date)
        OR
        (dr.scheduled = 1 AND pr.day = dr.day)
    )
JOIN
    drivers AS d ON dr.driver_id = d.id
WHERE
    pr.passenger_id = %s
    AND dr.start_area = %s
    AND dr.start_country = %s
    AND dr.destination_area = %s
    AND dr.destination_country = %s
    AND dr.hours = %s
    AND dr.day = %s
    AND dr.date = %s;
                '''
                cursor.execute(query, (user_id, start_area, start_country, end_area, end_country, hours, day, date))
                result = cursor.fetchall()

                if result:
                    return jsonify(user_info=result), 200
                else:
                    return jsonify({'error': 'No matches found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500
        
        
@app.route("/match_request", methods=['POST'])
def match_request():
    if request.method == 'POST':
        try:
            data = request.get_json()
            passenger_route_id = data.get('passenger_route_id')
            driver_route_id = data.get('driver_route_id')
            passenger_id = data.get('user_id')
            driver_id = data.get('driver_id')
            print(passenger_id)
            print(driver_id)
            print(passenger_route_id)
            print(driver_route_id)

            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Update the card details in the database
                query = "INSERT INTO match_table(passenger_id, driver_id, drivers_route_id, passengers_route_id ,is_match) VALUES(%s,%s,%s,%s,%s)"
                cursor.execute(query, (passenger_id,driver_id, driver_route_id,passenger_route_id,0))
                print(f"SQL Query: {query}")

            conn.commit()
            conn.close()

            return jsonify({'message': 'Card details updated successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500
        
@app.route("/match_confirm", methods=['POST'])
def match_confirm():
    if request.method == 'POST':
        try:
            data = request.get_json()
            passenger_route_id = data.get('passenger_route_id')
            driver_route_id = data.get('driver_route_id')
            passenger_id = data.get('passenger_id')
            driver_id = data.get('driver_id')
            print(passenger_id)
            print(driver_id)
            print(passenger_route_id)
            print(driver_route_id)

            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Update the card details in the database
                query = '''
UPDATE match_table
SET is_match = 1
WHERE passenger_id = %s AND driver_id = %s AND drivers_route_id = %s AND passengers_route_id = %s;

'''
                cursor.execute(query, (passenger_id,driver_id, driver_route_id,passenger_route_id))
                print(f"SQL Query: {query}")

            conn.commit()
            conn.close()

            return jsonify({'message': 'Card details updated successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

@app.route("/see_matches_passenger", methods=['GET'])
def see_matches_passenger():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = '''
                SELECT
                    d.first_name AS driver_first_name,
                    d.last_name AS driver_last_name,
                    d.telephone AS driver_telephone,
                    d.email AS driver_email
                FROM
                    match_table m
                JOIN
                    drivers d ON m.driver_id = d.id
                WHERE
                    m.passenger_id = %s AND m.is_match = 1;
                '''
                cursor.execute(query, (user_id,))
                result = cursor.fetchall()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result:  # Replace 'default_value' with a suitable default
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        
@app.route("/see_matches_driver", methods=['GET'])
def see_matches_driver():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = '''
               SELECT
    m.passengers_route_id AS passengers_route_id,
    pr.start_area AS passenger_start_area,
    pr.destination_area AS passenger_destination_area,
    p.ID AS passenger_id,
    p.first_name AS passenger_first_name,
    p.last_name AS passenger_last_name,
    p.telephone AS passenger_phone,
    p.email AS passenger_email
FROM
    match_table m
JOIN
    passengers p ON m.passenger_id = p.id
JOIN
    passenger_routes pr ON m.passengers_route_id = pr.id
WHERE
    m.driver_id = %s AND m.is_match = 1;

                '''
                cursor.execute(query, (user_id,))
                result = cursor.fetchall()

                # Print the user_info for debugging
                print("User information from the database:", result)
                print("User ID from the database:", user_id)

            if result:
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'User not found or no matches found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500


@app.route("/save_driver_route_airport", methods=['POST'])
def save_driver_route_airport():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO drivers_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, driver_id, scheduled ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id, 1))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Driver route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405


@app.route("/save_passenger_route_airport", methods=['POST'])
def save_passenger_route_airport():
    if request.method == 'POST':
        try:
            data = request.get_json()

            # Get parameters from the request
            user_id = data.get('user_id')  # Assuming you have the user_id
            start_street = data.get('start_street')
            start_area = data.get('start_area')
            start_country = data.get('start_country')
            destination_street = data.get('destination_street')
            destination_area = data.get('destination_area')
            destination_country = data.get('destination_country')
            day = data.get('day')
            date = data.get('date')
            hours = data.get('hours')
            minutes = data.get('minutes')
            capacity = data.get('capacity')
            print(user_id)
            # Connect to the database
            conn = pymysql.connect(**config2)

            with conn.cursor() as cursor:
                # Insert the driver route details into the database
                query = "INSERT INTO passenger_routes  (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, passenger_id, scheduled) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
                cursor.execute(query, ( start_street,start_area, start_country, destination_street, destination_area, destination_country,  capacity,day, date, hours, minutes, user_id, 1))

            conn.commit()
            conn.close()

            return jsonify({'message': 'Passenger route saved successfully'}), 200

        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'Internal server error'}), 500

    return jsonify({'error': 'Method not allowed'}), 405


@app.route("/see_match_requests_driver", methods=['GET'])
def see_match_requests_driver():
    if request.method == 'GET':
        try:
            user_id = request.args.get('user_id')
            print("Received user_id:", user_id)

            conn = pymysql.connect(**config2)  # connection with the database

            with conn.cursor() as cursor:
                query = '''
 SELECT
    pr.id AS passenger_route_id,
    dr.id AS drivers_route_id,
    p.id AS passenger_id,
    p.first_name AS passenger_first_name,
    p.last_name AS passenger_last_name,
    p.telephone AS passenger_telephone,
    p.email AS passenger_email,
    pr.start_area AS passenger_start_area,
    pr.destination_area AS passenger_destination_area,
    pr.hours AS hours,
    pr.minutes AS minutes
FROM
    match_table m
JOIN
    passengers p ON m.passenger_id = p.id
JOIN
    passenger_routes pr ON m.passengers_route_id = pr.id
JOIN
    drivers_routes dr ON m.drivers_route_id = dr.id  -- Include this JOIN for drivers_routes
WHERE
    m.driver_id = %s AND m.is_match = 0;


                '''
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()

                # Print the username for debugging
                print("Username from the database:", result)
                print("id from the database:", user_id)

            if result:  # Replace 'default_value' with a suitable default
                return jsonify(user_info=result), 200
            else:
                return jsonify({'error': 'username not found'}), 404
        except Exception as e:
            print(f"An error occurred: {str(e)}")
            traceback.print_exc()  # Print the traceback for debugging
            return jsonify({'error': 'internal server error'}), 500
        
if __name__ == '__main__':
    try:
        app.run(host='0.0.0.0', port=5000)
    except Exception as e:
        print(f"An error occurred: {e}")