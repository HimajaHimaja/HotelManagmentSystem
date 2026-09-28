# Hotel Room Management System
## Technical Requirements Document

Backend: Python + Flask
Frontend: HTML + CSS
Storage: Manual 
Architecture: Modular Layered Architecture

# Purpose
This document defines the technical structure of the Hotel Room Management System.

It is the primary technical reference for the development team and defines:

* Project structure
* Modules
* Classes
* Functions
* Data structures
* Routes
* Role permissions
* Room states
* Module dependencies
* Core workflows

The system is intentionally lightweight and does not introduce unnecessary frameworks or external services.


# Technology Stack
| Layer          | Technology                  |
| -------------- | --------------------------- |
| Backend        | Python                      |
| Web Framework  | Flask                       |
| Frontend       | HTML                        |
| Styling        | CSS                         |
| Storage        | Python dictionaries / lists |
| Authentication | Flask Session               |

# Architecture

HTML / CSS Frontend
        │
        ▼
   Flask Routes
        │
        ▼
   Service Layer
        │
        ▼
    Data Store
        │
        ▼
     Models

### Route Layer

Handles:

* HTTP requests
* Authentication checks
* Role authorization
* Request data
* Responses

### Service Layer

Handles:

* Business logic
* Validation
* Room state changes
* Check-in
* Check-out
* Cleaning operations

### Data Store

Handles:

* Runtime data
* Create
* Read
* Update
* Search
* Deactivate

### Models

Define the structure of:

* Users
* Rooms
* Room types
* Customers

# Project Structure

hotel_room_management/
│
├── run.py
├── config.py
├── requirements.txt
├── README.md
├── TRD.md
│
├── app/
│   ├── __init__.py
│   │
│   ├── routes/
│   │   ├── auth_routes.py
│   │   ├── owner_routes.py
│   │   ├── reception_routes.py
│   │   └── cleaner_routes.py
│   │
│   ├── services/
│   │   ├── auth_service.py
│   │   ├── room_service.py
│   │   ├── room_type_service.py
│   │   ├── checkin_service.py
│   │   ├── checkout_service.py
│   │   ├── cleaning_service.py
│   │   └── dashboard_service.py
│   │
│   ├── models/
│   │   ├── user.py
│   │   ├── room.py
│   │   ├── room_type.py
│   │   └── customer.py
│   │
│   ├── data/
│   │   ├── data_store.py
│   │   └── initial_data.py
│   │
│   ├── utils/
│   │   ├── constants.py
│   │   ├── validators.py
│   │   ├── generators.py
│   │   └── decorators.py
│   │
│   └── frontend/
│       ├── login.html
│       │
│       ├── owner/
│       │   ├── dashboard.html
│       │   ├── rooms.html
│       │   └── room_types.html
│       │
│       ├── reception/
│       │   ├── dashboard.html
│       │   ├── checkin.html
│       │   └── checkout.html
│       │
│       └── cleaner/
│           ├── dashboard.html
│           └── cleaning.html
│
└── tests/
    ├── test_auth.py
    ├── test_rooms.py
    ├── test_checkin.py
    ├── test_checkout.py
    └── test_cleaning.py


# Application Modules

Authentication
Room Management
Room Type & Pricing
Customer Check-in
Customer Check-out
Cleaning Management
Dashboard

# User Roles
## Owner

access to:
* Room management
* Room types
* Room pricing
* Room availability
* Maintenance
* Occupant information

## Reception

access to:
* Available rooms
* Room types and prices
* Customer check-in
* Room assignment
* Key-card generation
* Customer password generation
* Customer check-out
* Occupied rooms

## Cleaner

access to:
* Cleaning queue
* Cleaning status
* Room information required for cleaning
* Mark room as ready

Cleaner cannot modify:
* Customer information
* Pricing
* Room types
* Staff accounts
* Room configuration

# Data Store
File: app/data/data_store.py
The system uses a manual NoSQL-style runtime data store.

Collections:
users
rooms
room_types
customers

The data exists only while the application is running.

Application Start
       ↓
Data Loaded
       ↓
Application Running
       ↓
Application Stop
       ↓
Data Lost

File: app/data/initial_data.py

Responsible for loading initial development data.

# Models
## User

File: app/models/user.py
Class: User
Fields:
id
username
password
name
role
active

## Room
File: app/models/room.py
Class:Room

Fields:
id
room_number
room_type_id
price
status
floor
active

## Room Type
File: app/models/room_type.py
Class: RoomType

Fields:
id
name
description
price
active

## Customer
File: app/models/customer.py
Class: Customer

Fields:
id
name
phone
room_id
check_in
expected_checkout
actual_checkout
key_card_number
password
active

# Room Status
The system supports four room states:
AVAILABLE
OCCUPIED
CLEANING
MAINTENANCE

State flow:

AVAILABLE
    │
    │ Check-in
    ▼
OCCUPIED
    │
    │ Check-out
    ▼
CLEANING
    │
    │ Cleaning complete
    ▼
AVAILABLE

Maintenance:

AVAILABLE
    ↕
MAINTENANCE

Only `AVAILABLE` rooms can be assigned to customers.

# Authentication
File: app/services/auth_service.py
Class: AuthService

Functions:
login()
logout()
validate_user()
get_current_user()

Authentication uses Flask sessions.

Session information:
user_id
role

Routes:
GET  /login
POST /login
POST /logout

# Authorization
File: app/utils/decorators.py
Responsible for:
* Checking whether a user is logged in
* Checking the user's role
* Blocking unauthorized operations

Role routing:
OWNER      → Owner routes
RECEPTION  → Reception routes
CLEANER    → Cleaner routes

# Room Service
File: app/services/room_service.py
Class: RoomService

Functions:
create_room()
update_room()
deactivate_room()
get_room()
get_all_rooms()
get_available_rooms()
get_occupied_rooms()
get_cleaning_rooms()
get_maintenance_rooms()
change_room_status()

Responsibilities:
* Room creation
* Room updates
* Room availability
* Room status
* Room deactivation
* Maintenance status


# Room Type Service
File: app/services/room_type_service.py
Class: RoomTypeService

Functions:
create_room_type()
update_room_type()
deactivate_room_type()
get_room_type()
get_all_room_types()
update_price()

Room types may include:
Single
Double
Deluxe
Suite

# Check-in Service
File: app/services/checkin_service.py
Class: CheckInService

Functions:
check_in_customer()
validate_room_for_checkin()
create_customer_record()
assign_room()
generate_customer_credentials()

Responsibilities:
* Validate customer details
* Validate room availability
* Generate customer password
* Generate key-card number
* Create customer record
* Assign room
* Change room status to `OCCUPIED`

# Check-out Service
File: app/services/checkout_service.py
Class: CheckoutService

Functions:
checkout_customer()
validate_active_stay()
close_customer_record()
release_room()
mark_room_for_cleaning()

Responsibilities:
* Validate active customer
* Record checkout
* Close customer stay
* Change room status to `CLEANING`

# Cleaning Service
File: app/services/cleaning_service.py
Class:CleaningService

Functions:
get_cleaning_rooms()
start_cleaning()
mark_room_ready()
get_cleaning_status()

Responsibilities:

* Retrieve rooms requiring cleaning
* Manage cleaning status
* Mark rooms ready
* Change `CLEANING` to `AVAILABLE`

# Dashboard Service
File: app/services/dashboard_service.py
Class: DashboardService

Functions:
get_owner_dashboard()
get_reception_dashboard()
get_cleaner_dashboard()

# Dashboard Data
## Owner
Total Rooms
Available Rooms
Occupied Rooms
Cleaning Rooms
Maintenance Rooms
Room Types
Current Occupants

## Reception
Available Rooms
Occupied Rooms
Room Types
Room Prices
Check-in
Check-out

## Cleaner
Cleaning Rooms
Room Number
Room Type
Cleaning Status

# Generators
File: app/utils/generators.py

Functions:
generate_four_digit_password()
generate_key_card_number()

The four-digit password is generated during check-in.

The key-card number must be unique for active assignments.


# Validators
File: app/utils/validators.py

Functions:
validate_customer_name()
validate_phone()
validate_room_number()
validate_price()
validate_room_type()
validate_checkout_date()
validate_room_status()

All important validation must be performed on the backend.

# Constants
File: app/utils/constants.py
Contains:
OWNER
RECEPTION
CLEANER

AVAILABLE
OCCUPIED
CLEANING
MAINTENANCE

All modules should use centralized constants instead of repeatedly defining status strings.

# Owner Routes
File:
app/routes/owner_routes.py

Routes:
/owner/dashboard
/owner/rooms
/owner/rooms/create
/owner/rooms/update
/owner/rooms/deactivate
/owner/room-types
/owner/room-types/create
/owner/room-types/update
/owner/occupants

# Reception Routes
File:app/routes/reception_routes.py

Routes:
/reception/dashboard
/reception/rooms
/reception/occupied
/reception/checkin
/reception/checkout

# Cleaner Routes
File: app/routes/cleaner_routes.py

Routes:
/cleaner/dashboard
/cleaner/cleaning
/cleaner/rooms/ready

# Route-to-Service Linkage
Owner Routes
     ↓
RoomService
RoomTypeService
DashboardService

Reception Routes
     ↓
CheckInService
CheckoutService
RoomService
DashboardService

Cleaner Routes
     ↓
CleaningService
DashboardService

# Backend Request Flow
HTTP Request
     ↓
Authentication
     ↓
Authorization
     ↓
Route
     ↓
Service
     ↓
Validation
     ↓
Business Logic
     ↓
Data Store
     ↓
Response

# Check-in Flow
Reception
    ↓
Available Rooms
    ↓
Customer Details
    ↓
Room Validation
    ↓
Generate Key Card
    ↓
Generate 4-Digit Password
    ↓
Create Customer
    ↓
Assign Room
    ↓
Room = OCCUPIED

# Check-out Flow
Reception
    ↓
Occupied Room
    ↓
Validate Customer
    ↓
Checkout
    ↓
Close Customer Stay
    ↓
Room = CLEANING

# Cleaning Flow
Checkout
    ↓
Room = CLEANING
    ↓
Cleaner Dashboard
    ↓
Clean Room
    ↓
Mark Ready
    ↓
Room = AVAILABLE


# Frontend
Frontend uses only:
HTML
CSS

The frontend contains:

login.html
owner/
    dashboard.html
    rooms.html
    room_types.html
reception/
    dashboard.html
    checkin.html
    checkout.html
cleaner/
    dashboard.html
    cleaning.html

Frontend responsibilities:
* Display information
* Collect form data
* Submit requests
* Display responses
* Provide navigation

Business logic remains in Flask.

# Application Startup
run.py
   ↓
Create Flask Application
   ↓
Load Configuration
   ↓
Initialize Data Store
   ↓
Load Initial Data
   ↓
Register Routes
   ↓
Start Flask

# Main Dependency Structure

                    Flask Application
                           │
                           ▼
                         Routes
                           │
                           ▼
                        Services
                           │
                           ▼
                       Data Store
                           │
                           ▼
                         Models

Role-specific flow:
OWNER
  ↓
Owner Routes
  ↓
Room / RoomType / Dashboard Services


RECEPTION
  ↓
Reception Routes
  ↓
Check-in / Check-out / Room Services
 

CLEANER
  ↓
Cleaner Routes
  ↓
Cleaning Service

# Development Order
Project Setup
    ↓
Flask Configuration
    ↓
Constants
    ↓
Data Store
    ↓
Models
    ↓
Initial Data
    ↓
Authentication
    ↓
Authorization
    ↓
Room Management
    ↓
Room Types & Pricing
    ↓
Check-in
    ↓
Check-out
    ↓
Cleaning
    ↓
Dashboards
    ↓
Validation
    ↓
Error Handling
    ↓
Testing
    ↓
Frontend Refinement


