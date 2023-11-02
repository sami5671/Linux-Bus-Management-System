## Methodology of this Project
The provided Bash script implements a simple Bus Reservation System. Below is the methodology of this code:

### To Run this Code:
git bash --> then-->  ./project.sh

## Initialization:
The script starts by initializing two associative arrays:
bus_seat_limits stores the seat limits for different buses.
bus_available_seats stores the current available seats for each bus.
Two file paths, user_credentials_file and booked_tickets_file, are set to store user credentials and booked tickets information.

## Pre-login Menu (pre_login_menu):
A function is defined to display the pre-login menu with three options:
Login: Registered users can log in.
Register: New users can register.
Exit: To exit the system.
## User Registration (register Function):
Users are prompted to enter a unique username and password.
The script checks if the username already exists in the user_credentials_file. If not, it saves the new user's credentials in the file.
## User Login (login Function):
Registered users are prompted to enter their username and password.
The script checks if the provided username and password match the entries in the user_credentials_file. If the login is successful, users proceed to the main menu.


## Main Menu (main_menu Function):
After logging in, users are presented with a main menu.
The main menu offers the following options:
Book Tickets: Allows users to select and book bus tickets.
Check Bus Status: Provides real-time information about the bus status.
Cancel Tickets: Permits users to cancel their booked tickets.
Logout: Logs the user out and returns to the pre-login menu.
Exit: Exits the system.
## Booking Tickets (book_tickets Function):
Users can view available buses and their seat availability.
After selecting a bus and the number of tickets, users proceed to a simulated payment process.
Payment is simulated with card details (you can replace this with actual payment integration).
A reference number is generated for the booking.
Booking information is saved in the booked_tickets_file, and a confirmation email is sent to the user.
Users can return to the book tickets section or the main menu.
## Checking Bus Status (check_bus_status Function):
Users can check real-time status information for each available bus.
The script provides details such as the bus route, departure time, and a randomly generated status (you can replace this with actual status data).
Users have the option to go back to the main menu or book tickets.




## Canceling Tickets (cancel_tickets Function):
Users can view their booked tickets and select one for cancellation.
A warning is issued that tickets cannot be canceled if more than 2 minutes have passed since booking.
Users can cancel a ticket within the time limit, which updates the canceled_tickets.txt file.
## Main Program Loop:
The script runs in a loop, repeatedly displaying the pre-login menu until the user chooses to exit the system.Users can log in, register, or exit the system.

# Overall:
The system provides a command-line interface for bus ticket reservation and management. It includes functionalities for registration, login, booking, checking bus status, and canceling tickets. The script stores user credentials and booking information in text files. Some functionalities are simulated, like payment processing, and can be enhanced with real-world integration. It provides a basic example of a bus reservation system that can be extended and improved for practical use.


 
