Business Requirements Document (BRD)

Hotel Room Management System

1. Problem Statement

Small and medium-sized hotels often manage room availability, pricing, cleaning status, and customer check-ins manually using registers, spreadsheets, or disconnected systems. This can lead to incorrect room availability, pricing mistakes, delays in housekeeping updates, and difficulty tracking which rooms are occupied or ready for customers.

The **Hotel Room Management System** will provide a simple web-based application for hotel owners, reception staff, and cleaners to manage the hotel's rooms and daily operations. The system will not include online customer registration or customer accounts. Instead, customers will receive a **room key card number and a randomly generated four-digit password at reception**, which can be used for basic room access/verification within the system.

The application will use runtime memory for storing information during operation and will focus only on essential hotel room management functionality.

---

2. Objectives

The system should:

* Allow the owner to manage hotel rooms and room types.
* Allow the owner to configure and update room prices.
* Allow reception staff to check customers in and out.
* Provide customers with a room key-card number and randomly generated 4-digit password.
* Allow reception staff to view current room availability.
* Allow cleaners to update room cleaning status.
* Clearly distinguish available, occupied, cleaning, and maintenance rooms.
* Provide a simple dashboard for each staff role.

---

3. User Roles

Owner
The owner has complete management access.

The owner can:

* Add new rooms.
* Update room information.
* Remove/deactivate rooms.
* Create different room types.
* Set and update room prices.
* View room availability.
* View current occupants.
* View basic booking/check-in information.

Example room types:

```text
Single Room
Double Room
Deluxe Room
Suite
```

---

Reception

Reception staff handle customer-facing operations.

They can:

* View available rooms.
* View room types and prices.
* Check in customers.
* Check out customers.
* Assign a room to a customer.
* Generate a random 4-digit customer password.
* Assign/generate a key-card number.
* View currently occupied rooms.
* Mark a room for cleaning after checkout.

Customer check-in information may include:

```text
Customer Name
Phone Number
Room
Check-in Date/Time
Expected Checkout
Key Card Number
4-digit Password
```

---

Cleaner
Cleaners have limited access.

They can:

* View rooms requiring cleaning.
* View cleaning status.
* Mark a room as **Cleaning**.
* Mark a room as **Clean/Ready**.
* View basic room information required for cleaning.

They cannot modify room prices, customer information, or staff accounts.

---

4. Room Status

Each room will have a simple status:

```text
AVAILABLE
OCCUPIED
CLEANING
MAINTENANCE
```

Example:

```text
Room 101 → AVAILABLE
Room 102 → OCCUPIED
Room 103 → CLEANING
Room 104 → MAINTENANCE
```

---

5. Basic Workflow

```text
Owner creates rooms
       ↓
Reception sees available rooms
       ↓
Customer arrives
       ↓
Reception assigns room
       ↓
System generates 4-digit password
       ↓
Key card number assigned
       ↓
Room becomes OCCUPIED
       ↓
Customer checks out
       ↓
Room becomes CLEANING
       ↓
Cleaner cleans room
       ↓
Cleaner marks room READY
       ↓
Room becomes AVAILABLE
```

The first version will intentionally avoid unnecessary features such as online booking, payment gateways, customer accounts, reviews, restaurant management, or complex hotel administration.