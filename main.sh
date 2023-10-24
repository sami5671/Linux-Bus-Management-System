#!/bin/bash
# Initialize available buses with their respective seat limits
declare -A bus_seat_limits=( ["Bus A"]=50 ["Bus B"]=40 ["Bus C"]=30 )

# Initialize available seats for each bus
declare -A bus_available_seats=( ["Bus A"]=50 ["Bus B"]=40 ["Bus C"]=30 )

# File to store registered user credentials
user_credentials_file="user_credentials.txt"
# File to store booked tickets
booked_tickets_file="booked_tickets.txt"

# Function to display the pre-login menu
pre_login_menu() {
  clear
  echo "------------------->>>>>>>>>>>>>>>>>> BUS RESERVATION SYSTEM <<<<<<<<<<<<<<<<<<<----------------"
  echo "1. Login"
  echo "2. Register"
  echo "3. Exit"
}

# Function for user registration
register() {
  clear
  echo "------------------->>>>>>>>>>>>>>>>>> USER REGISTRATION <<<<<<<<<<<<<<<<<<<----------------"
  read -p "Enter a username: " new_username
  # Check if the username already exists
  if grep -q "^$new_username:" "$user_credentials_file"; then
    echo "Username already exists. Please choose a different username."
  else
    read -p "Enter a password: " new_password
    # Store the new user's credentials in the user_credentials_file
    echo "$new_username:$new_password" >> "$user_credentials_file"
    echo "Registration successful! You can now log in."
  fi
  read -n 1 -s -r -p "Press any key to continue..."
}

# Function for user login
login() {
  clear
  echo "------------------->>>>>>>>>>>>>>>>>> LOGIN SYSTEM <<<<<<<<<<<<<<<<<<<----------------"
  read -p "Enter your username: " username
  read -p "Enter your password: " password
  # Check if username and password are correct
  # Add your authentication logic here
  if grep -q "^$username:$password" "$user_credentials_file"; then
    echo "Login successful!"
    read -n 1 -s -r -p "Press any key to continue..."
    main_menu "$username"  # Pass the username to the main menu
  else
    echo "Login failed. Invalid username or password."
    read -n 1 -s -r -p "Press any key to continue..."
  fi
}

# Function for the main menu
main_menu() {
  local username="$1"  # Get the username passed from login
  while true; do
    clear
    echo "------------------->>>>>>>>>>>>>>>>>> BUS RESERVATION SYSTEM- WELCOME <<<-----, $username"
    echo "1. Book Tickets"
    echo "2. Check Bus Status"
    echo "3. Cancel Tickets"
    echo "4. Logout"
    echo "5. Exit"
    read -p "Enter your choice: " choice
    case $choice in
      1)
        book_tickets
        ;;
      2)
        check_bus_status 
        ;;
      3)
        cancel_tickets
        ;;
      4)
        return  # Return to the pre-login menu (logout)
        ;;
      5)
        clear
        echo "Exiting the Bus Reservation System. Goodbye!"
        exit 0
        ;;
      *)
        echo "Invalid choice. Please select a valid option."
        read -n 1 -s -r -p "Press any key to continue..."
        ;;
    esac
  done
}

# Function for booking tickets
book_tickets() {
  while true; do
    clear
    
    echo "------------------->>>>>>>>>>>>>>>>>> BOOKING OF TICKETS <<<<<<<<<<<<<<<<<<<----------------"
    echo "Available Buses with Available Seats:"
    
    # Loop through the available buses and display seat information
    available_buses=("${!bus_seat_limits[@]}")
    for ((i = 0; i < ${#available_buses[@]}; i++)); do
      bus="${available_buses[i]}"
      seat_limit="${bus_seat_limits["$bus"]}"
      available_seats="${bus_available_seats["$bus"]}"
      echo "$(($i + 1)). $bus - Available Seats: $available_seats/$seat_limit"
    done
    
    echo "0. Back to Main Menu"  # Added "Back to Main Menu" option
    read -p "Select a bus (0 to go back, 1-${#available_buses[@]}): " bus_choice
    
    if [ "$bus_choice" -eq 0 ]; then
      return  # Go back to the main menu
    elif [ "$bus_choice" -ge 1 ] && [ "$bus_choice" -le ${#available_buses[@]} ]; then
      selected_bus="${available_buses[$(($bus_choice - 1))]}"
      seat_limit="${bus_seat_limits["$selected_bus"]}"
      available_seats="${bus_available_seats["$selected_bus"]}"
      
      echo "You have selected: $selected_bus"
      echo "Seat Limit: $seat_limit"
      echo "Available Seats: $available_seats"
      
      echo "One ticket costs 500 BDT."
      
      read -p "Enter number of tickets: " num_tickets
      
      if [ "$num_tickets" -le "$available_seats" ]; then
        # Calculate the total price
        total_price=$((num_tickets * 500))  # Assuming 1 ticket costs 500 TK
        
        # Generate a 4-digit reference number for the booking
        reference_number=$((1000 + RANDOM % 9000))
        
        # Update available seats
        new_available_seats=$((available_seats - num_tickets))
        bus_available_seats["$selected_bus"]=$new_available_seats
        
        # Capture the booking time
        booking_time=$(date +"%Y-%m-%d %H:%M:%S")
        
        # Demo card details
        echo " Here is the Demo Card Details--------->>>>>    Credit card number: 1234, card_expiration: 12/25, CVV: 123   <<<<<<<-------------"
    
        # Payment processing logic
        read -p "Enter your credit card number: " credit_card_number
        read -p "Enter the card expiration date (MM/YY): " card_expiration
        read -p "Enter the CVV: " cvv
        
        # Simulate payment processing (you can replace this with actual payment gateway integration)
        if [ "$credit_card_number" = "1234" ] && [ "$card_expiration" = "12/25" ] && [ "$cvv" = "123" ]; then
          # Payment successful
          echo "Payment successful!"
          
          # Display the total price
          echo "Total Price: $total_price BDT"
          
          # Prompt the user for their email address
          read -p "Enter your email address for booking confirmation: " user_email
          
          # Save booking information to a text file
          booking_info="Reference Number: $reference_number, Bus: $selected_bus, Tickets: $num_tickets, Total Price: $total_price BDT, Booking Time: $booking_time"
          echo "$booking_info" >> "$booked_tickets_file"
          echo "Tickets booked successfully! Your reference number is $reference_number."
          
          # Send an email to the user with payment details and booking time
          email_subject="Bus Ticket Booking Confirmation"
          email_body="Dear user,\n\nYour bus ticket booking has been confirmed with the following details:\n\n$booking_info\n\nThank you for choosing our service!\n\nBest regards,\nThe Bus Reservation Team"
          
          # Use the mail command to send the email
          echo -e "$email_body" | mail -s "$email_subject" "$user_email"
          
          echo "An email with booking details has been sent to $user_email."
          read -n 1 -s -r -p "Press any key to continue..."
        else
          # Payment failed
          echo "Payment failed. Please check your payment details and try again."
          read -n 1 -s -r -p "Press any key to continue..."
        fi
        
        # Provide an option to go back to the book bus section
        echo "1. Back to Book Bus Section"
        read -p "Enter your choice (1 to go back): " back_choice
        if [ "$back_choice" -eq 1 ]; then
          continue  # Go back to the book bus section
        fi
      else
        echo "Sorry, the requested number of tickets exceeds the available seats for $selected_bus."
        read -n 1 -s -r -p "Press any key to continue..."
      fi
    else
      echo "Invalid choice. Please select a valid bus or 0 to go back."
      read -n 1 -s -r -p "Press any key to continue..."
    fi
  done
}


# Function for checking bus status and seat availability
check_bus_status() {
  while true; do
    clear
    echo "------------------->>>>>>>>>>>>>>>>>>>>>> CHECKING BUS STATUS <<<<<<<<<<<<<<<<<<<<<<<<-----------------"

    # Define bus information, including route and schedule
    declare -A bus_info=(
      ["Bus A"]="Route: Route A, Departure: 08:00 AM, Arrival: 10:30 AM"
      ["Bus B"]="Route: Route B, Departure: 09:00 AM, Arrival: 11:30 AM"
      ["Bus C"]="Route: Route C, Departure: 10:00 AM, Arrival: 12:30 PM"
    )

    # Fetch real-time status for each bus
    for bus in "${!bus_info[@]}"; do
      # Generate a random status (you can replace this with actual data)
      bus_statuses=("On Time" "Delayed" "Cancelled" "Arriving Soon" "Boarding")
      random_index=$((RANDOM % ${#bus_statuses[@]}))
      status="${bus_statuses[$random_index]}"

      echo "Bus: $bus"
      echo "${bus_info["$bus"]}"
      echo "Status: $status"
      echo "------------------------"
    done

    # Provide options to go back to the main menu or book tickets
    echo "0. Back to Main Menu"
    echo "B. Book Tickets"
    read -p "Enter your choice (0/B): " choice
    
    if [ "$choice" = "0" ]; then
      return  # Go back to the main menu
    elif [ "$choice" = "B" ] || [ "$choice" = "b" ]; then
      book_tickets  # Call the book_tickets function
    else
      echo "Invalid choice. Please select '0' to go back to the main menu or 'B' to book tickets."
      read -n 1 -s -r -p "Press any key to continue..."
    fi
  done
}
# Function for canceling tickets
cancel_tickets() {
  while true; do
    clear
    echo "------------------->>>>>>>>>>>>>>>>>>>>>> CANCEL TICKETS <<<<<<<<<<<<<<<<<<<<<<<<-----------------"
    echo "Booked Bus Tickets:"
    echo "----------------->>>>>>>>>>> WARNING!!!! YOU CANNOT CANCEL TICKETS. IF TIME LIMIT EXCEED TO 2 MINUTES <<<<<<<<<<<<<----"

    cat "$booked_tickets_file"
    read -p "Enter booking reference number (4 digits) or 0 to go back to the Main Menu: " reference_number

    if [ "$reference_number" -eq 0 ]; then
      return  # Go back to the main menu
    fi
  
    # Check if the reference number exists in the booked_tickets.txt file
    if grep -q "Reference Number: $reference_number" "$booked_tickets_file"; then
      # Find the canceled ticket entry
      canceled_ticket_info=$(grep "Reference Number: $reference_number" "$booked_tickets_file")
      # Extract the booking time from the canceled ticket info
      booking_time=$(grep "Reference Number: $reference_number" "$booked_tickets_file" | awk '{print $NF}')
      
      # Calculate the current time
      current_time=$(date +"%s")
      # Convert the booking time to seconds since epoch
      booking_time_seconds=$(date -d "$booking_time" +"%s")
      
      # Calculate the time difference in seconds
      time_diff=$((current_time - booking_time_seconds))
      
      # Check if the time difference is within the cancellation limit (2 minutes = 120 seconds)
      if [ "$time_diff" -le 120 ]; then
        # Remove the booking entry from booked_tickets.txt
        sed -i "/Reference Number: $reference_number/d" "$booked_tickets_file"
        
        # Add a header with a timestamp for the canceled ticket in canceled_tickets.txt
        cancel_timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo "Cancellation Timestamp: $cancel_timestamp" >> canceled_tickets.txt
        echo "$canceled_ticket_info" >> canceled_tickets.txt
        echo "" >> canceled_tickets.txt  # Add an empty line for separation

        echo "Ticket with reference number $reference_number canceled successfully!"
      else
        echo "Ticket cannot be canceled. Time limit for cancellation has expired."
      fi
    else
      echo "Invalid reference number. No matching booking found."
    fi
    read -n 1 -s -r -p "Press any key to continue..."
  done
}

# Main loop for the program
while true; do
  pre_login_menu
  read -p "Enter your choice: " pre_login_choice
  case $pre_login_choice in
    1)
      login
      ;;
    2)
      register
      ;;
    3)
      clear
      echo "Exiting the Bus Reservation System. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid choice. Please select a valid option."
      read -n 1 -s -r -p "Press any key to continue..."
      ;;
  esac
done