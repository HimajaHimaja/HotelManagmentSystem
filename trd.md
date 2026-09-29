# Hotel Room Management System

## Technical Requirements Document

## 1. Purpose

This document defines the technical structure of the **Hotel Room Management System MVP**.

The system is a lightweight Flask-based backend application that provides API endpoints for:

* Hotel room management
* Room type and pricing management
* Customer check-in
* Customer check-out
* Room cleaning management
* Runtime role-based access
* Role-specific dashboard information

The application intentionally avoids persistent databases, frontend components, authentication frameworks, and unnecessary architectural layers.

All application data exists only while the application is running.

---

# 2. Technology Stack

| Layer          | Technology                    |
| -------------- | ----------------------------- |
| Backend        | Python                        |
| Web Framework  | Flask                         |
| API            | Flask HTTP/JSON APIs          |
| Storage        | Python dictionaries and lists |
| Authentication | Runtime role verification     |
| Persistence    | None                          |
| Frontend       | None                          |

The application is an **API-only backend**.

---

# 3. Architecture

The system follows a lightweight layered architecture:

```text
HTTP/API Request
       │
       ▼
    Routes
       │
       ▼
   Services
       │
       ▼
 Runtime Data Store
```

The application does not use:

* HTML
* CSS
* JavaScript frontend
* Flask Sessions
* JWT
* Cookies
* External database
* ORM
* Explicit Data Model layer

`Hotel` and `Room` are ordinary Python classes used by the application where required. They are not part of a separate model architecture.

---

## 3.1 Route Layer

The Route Layer is responsible for:

* Receiving HTTP requests
* Reading request data
* Performing runtime role verification
* Calling the appropriate service
* Returning API responses
* Returning HTTP status codes

Routes must not contain business logic.

---

## 3.2 Service Layer

The Service Layer contains the application's business logic.

Responsibilities include:

* Room management
* Room type management
* Pricing
* Customer check-in
* Customer check-out
* Cleaning operations
* Runtime validation
* Dashboard calculations
* Room state transitions
* Credential generation

Services communicate with the runtime data store.

---

## 3.3 Runtime Data Store

The Runtime Data Store manages all application data using Python dictionaries and lists.

Responsibilities:

* Store runtime data
* Create records
* Read records
* Update records
* Search records
* Deactivate records
* Maintain relationships between runtime records

No data is persisted to disk or an external database.

### Data Lifecycle

```text
Application Start
       ↓
Initialize Runtime Data
       ↓
Load Initial Development Data
       ↓
Application Running
       ↓
Application Stop
       ↓
All Runtime Data Lost
```

---

# 4. MVP Project Structure

The project structure is intentionally minimized.

```text
hotel_room_management/
│
├── run.py
├── config.py
├── requirements.txt
├── README.md
├── TRD.md
│
└── app/
    ├── __init__.py
    │
    ├── routes/
    │   ├── owner_routes.py
    │   ├── reception_routes.py
    │   └── cleaner_routes.py
    │
    ├── services/
    │   ├── room_service.py
    │   ├── room_type_service.py
    │   ├── checkin_service.py
    │   ├── checkout_service.py
    │   ├── cleaning_service.py
    │   └── dashboard_service.py
    │
    ├── data/
    │   ├── data_store.py
    │   └── initial_data.py
    │
    └── utils/
        ├── constants.py
        ├── validators.py
        └── generators.py
```

There is intentionally no:

```text
models/
frontend/
templates/
static/
auth_service.py
decorators.py
```

for the MVP.

---

# 5. Application Modules

The MVP contains the following modules:

1. Room Management
2. Room Type & Pricing
3. Customer Check-in
4. Customer Check-out
5. Cleaning Management
6. Dashboard

Authentication is implemented as **runtime role verification** at the API boundary rather than as a standalone authentication module.

---

# 6. User Roles

The system supports three roles:

```text
OWNER
RECEPTION
CLEANER
```

---

## 6.1 Owner

The Owner can access:

* Room management
* Room types
* Room pricing
* Room availability
* Maintenance management
* Occupant information
* Owner dashboard

The Owner can:

* Create rooms
* Update rooms
* Deactivate rooms
* Create room types
* Update room types
* Deactivate room types
* Update room pricing
* Change rooms to/from maintenance where allowed
* View current occupants

---

## 6.2 Reception

Reception can access:

* Available rooms
* Occupied rooms
* Room types
* Room prices
* Customer check-in
* Room assignment
* Key-card generation
* Customer password generation
* Customer check-out
* Reception dashboard

Reception cannot:

* Create rooms
* Modify room configuration
* Modify room types
* Modify pricing
* Manage maintenance configuration

---

## 6.3 Cleaner

Cleaner can access:

* Cleaning queue
* Cleaning status
* Room information required for cleaning
* Cleaner dashboard
* Mark rooms as ready

Cleaner cannot modify:

* Customer information
* Pricing
* Room types
* Room configuration
* Staff information

---

# 7. Runtime Role Verification

The MVP does not use:

* Flask Session
* JWT
* Cookies
* Login persistence
* Token management

Instead, every protected API request provides the user's runtime role.

Example:

```text
Role: OWNER
```

or through a request header:

```text
X-Role: OWNER
```

The exact API mechanism can be standardized during implementation, but the role must be verified for every protected operation.

Example:

```text
HTTP Request
     ↓
Read Runtime Role
     ↓
Check Required Role
     ↓
Allowed → Service
Denied → 403 Forbidden
```

This mechanism is intended only for the MVP/runtime environment and does not represent production-grade authentication.

---

# 8. Runtime Data Store

File:

```text
app/data/data_store.py
```

The system uses an in-memory NoSQL-style runtime store.

The primary collections are:

```text
users
rooms
room_types
customers
```

Example conceptual structure:

```python
data_store = {
    "users": [],
    "rooms": [],
    "room_types": [],
    "customers": []
}
```

The data store is initialized when the application starts.

---

# 9. Initial Data

File:

```text
app/data/initial_data.py
```

This module provides development/runtime seed data.

It is responsible for:

* Creating initial users
* Creating initial room types
* Creating initial rooms
* Optionally creating sample customer records

Initial data exists only in memory.

---

# 10. Application Classes

The MVP does not use a dedicated Models layer.

Instead, required domain classes are defined directly in the appropriate application modules.

---

## 10.1 Hotel

The `Hotel` class represents the hotel/application runtime context.

Possible responsibilities include:

* Hotel identity
* Room collection
* Room type collection
* Customer collection
* Runtime hotel information

The class should remain lightweight and must not introduce database persistence.

---

## 10.2 Room

The `Room` class represents a hotel room.

Fields:

```text
id
room_number
room_type_id
price
status
floor
active
```

Example:

```text
Room
├── id
├── room_number
├── room_type_id
├── price
├── status
├── floor
└── active
```

---

# 11. Runtime User Structure

Users are represented using runtime dictionaries or lightweight objects.

Fields:

```text
id
username
password
name
role
active
```

Example:

```python
{
    "id": 1,
    "username": "owner",
    "password": "1234",
    "name": "Hotel Owner",
    "role": "OWNER",
    "active": True
}
```

---

# 12. Room Type Structure

Room types are stored in the runtime data store.

Fields:

```text
id
name
description
price
active
```

Example room types:

```text
Single
Double
Deluxe
Suite
```

Room type pricing is managed by the Owner.

---

# 13. Customer Structure

Customer records are stored in the runtime data store.

Fields:

```text
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
```

The customer record represents the current and historical runtime stay information.

---

# 14. Room Status

The system supports four room states:

```text
AVAILABLE
OCCUPIED
CLEANING
MAINTENANCE
```

---

## 14.1 Normal State Flow

```text
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
```

---

## 14.2 Maintenance Flow

```text
AVAILABLE
    ↕
MAINTENANCE
```

Maintenance operations must not affect an occupied room.

Only an `AVAILABLE` room can be assigned to a new customer.

---

# 15. Constants

File:

```text
app/utils/constants.py
```

Centralized constants must be used throughout the application.

### Roles

```text
OWNER
RECEPTION
CLEANER
```

### Room States

```text
AVAILABLE
OCCUPIED
CLEANING
MAINTENANCE
```

This prevents repeated hard-coded strings throughout services and routes.

---

# 16. Validators

File:

```text
app/utils/validators.py
```

The validation module contains reusable backend validation functions.

Functions:

```text
validate_customer_name()
validate_phone()
validate_room_number()
validate_price()
validate_room_type()
validate_checkout_date()
validate_room_status()
```

All important validation must occur on the backend.

Routes should not depend on client-side validation.

---

# 17. Generators

File:

```text
app/utils/generators.py
```

Functions:

```text
generate_four_digit_password()
generate_key_card_number()
```

---

## 17.1 Customer Password

A four-digit password is generated during customer check-in.

Example:

```text
4837
```

The password must be generated by the backend.

---

## 17.2 Key Card

A key-card number is generated during check-in.

The key-card number must be unique among active customer assignments.

---

# 18. Room Service

File:

```text
app/services/room_service.py
```

Class:

```text
RoomService
```

Functions:

```text
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
```

Responsibilities:

* Room creation
* Room updates
* Room lookup
* Room availability
* Room status management
* Room deactivation
* Maintenance management

RoomService must enforce valid room state transitions.

---

# 19. Room Type Service

File:

```text
app/services/room_type_service.py
```

Class:

```text
RoomTypeService
```

Functions:

```text
create_room_type()
update_room_type()
deactivate_room_type()
get_room_type()
get_all_room_types()
update_price()
```

Responsibilities:

* Room type creation
* Room type updates
* Room type deactivation
* Room type lookup
* Pricing management

Only the Owner can perform management operations.

---

# 20. Check-in Service

File:

```text
app/services/checkin_service.py
```

Class:

```text
CheckInService
```

Functions:

```text
check_in_customer()
validate_room_for_checkin()
create_customer_record()
assign_room()
generate_customer_credentials()
```

Responsibilities:

* Validate customer details
* Validate selected room
* Confirm room is `AVAILABLE`
* Generate customer password
* Generate key-card number
* Create customer record
* Assign room
* Change room status to `OCCUPIED`

---

# 21. Check-out Service

File:

```text
app/services/checkout_service.py
```

Class:

```text
CheckoutService
```

Functions:

```text
checkout_customer()
validate_active_stay()
close_customer_record()
release_room()
mark_room_for_cleaning()
```

Responsibilities:

* Validate active customer stay
* Record actual checkout
* Close customer stay
* Release room
* Change room status to `CLEANING`

---

# 22. Cleaning Service

File:

```text
app/services/cleaning_service.py
```

Class:

```text
CleaningService
```

Functions:

```text
get_cleaning_rooms()
start_cleaning()
mark_room_ready()
get_cleaning_status()
```

Responsibilities:

* Retrieve rooms requiring cleaning
* Manage cleaning state
* Start cleaning
* Mark room as ready
* Change `CLEANING` to `AVAILABLE`

---

# 23. Dashboard Service

File:

```text
app/services/dashboard_service.py
```

Class:

```text
DashboardService
```

Functions:

```text
get_owner_dashboard()
get_reception_dashboard()
get_cleaner_dashboard()
```

The dashboard service calculates information from the runtime data store.

---

# 24. Dashboard Data

## Owner Dashboard

The Owner dashboard provides:

```text
Total Rooms
Available Rooms
Occupied Rooms
Cleaning Rooms
Maintenance Rooms
Room Types
Current Occupants
```

---

## Reception Dashboard

The Reception dashboard provides:

```text
Available Rooms
Occupied Rooms
Room Types
Room Prices
Check-in Information
Check-out Information
```

---

## Cleaner Dashboard

The Cleaner dashboard provides:

```text
Cleaning Rooms
Room Number
Room Type
Cleaning Status
```

---

# 25. Owner API Routes

File:

```text
app/routes/owner_routes.py
```

Routes:

```text
GET  /owner/dashboard

GET  /owner/rooms
POST /owner/rooms/create
PUT  /owner/rooms/update
POST /owner/rooms/deactivate

GET  /owner/room-types
POST /owner/room-types/create
PUT  /owner/room-types/update

GET  /owner/occupants
```

Owner routes require:

```text
OWNER
```

runtime role verification.

---

# 26. Reception API Routes

File:

```text
app/routes/reception_routes.py
```

Routes:

```text
GET  /reception/dashboard
GET  /reception/rooms
GET  /reception/occupied

POST /reception/checkin
POST /reception/checkout
```

Reception routes require:

```text
RECEPTION
```

runtime role verification.

---

# 27. Cleaner API Routes

File:

```text
app/routes/cleaner_routes.py
```

Routes:

```text
GET  /cleaner/dashboard
GET  /cleaner/cleaning
POST /cleaner/rooms/ready
```

Cleaner routes require:

```text
CLEANER
```

runtime role verification.

---

# 28. Route-to-Service Mapping

```text
OWNER
 │
 ├── Owner Routes
 │       │
 │       ├── RoomService
 │       ├── RoomTypeService
 │       └── DashboardService
 │
RECEPTION
 │
 ├── Reception Routes
 │       │
 │       ├── CheckInService
 │       ├── CheckoutService
 │       ├── RoomService
 │       └── DashboardService
 │
CLEANER
 │
 └── Cleaner Routes
         │
         ├── CleaningService
         └── DashboardService
```

---

# 29. Backend Request Flow

Every protected request follows this general flow:

```text
HTTP Request
     ↓
Runtime Role Verification
     ↓
Route
     ↓
Request Validation
     ↓
Service
     ↓
Business Logic
     ↓
Runtime Data Store
     ↓
API Response
```

Routes are responsible for request/response handling.

Services are responsible for business decisions.

The data store is responsible for runtime data management.

---

# 30. Check-in Workflow

```text
Reception API
      ↓
Customer Details
      ↓
Validate Customer
      ↓
Validate Room
      ↓
Check Room = AVAILABLE
      ↓
Generate Key Card
      ↓
Generate 4-Digit Password
      ↓
Create Customer Record
      ↓
Assign Room
      ↓
Room = OCCUPIED
      ↓
Return Check-in Response
```

A room that is:

```text
OCCUPIED
CLEANING
MAINTENANCE
```

cannot be assigned to a customer.

---

# 31. Check-out Workflow

```text
Reception API
      ↓
Select Active Customer
      ↓
Validate Active Stay
      ↓
Record Actual Checkout
      ↓
Close Customer Stay
      ↓
Release Room
      ↓
Room = CLEANING
      ↓
Return Checkout Response
```

The room must not become `AVAILABLE` immediately after checkout.

It must first go through cleaning.

---

# 32. Cleaning Workflow

```text
Customer Checkout
       ↓
Room = CLEANING
       ↓
Cleaner Dashboard
       ↓
Cleaning Queue
       ↓
Start Cleaning
       ↓
Complete Cleaning
       ↓
Mark Room Ready
       ↓
Room = AVAILABLE
```

Only the Cleaner can complete the cleaning workflow.

---

# 33. Maintenance Workflow

Maintenance is managed by the Owner.

Normal flow:

```text
AVAILABLE
    ↓
MAINTENANCE
```

After maintenance:

```text
MAINTENANCE
    ↓
AVAILABLE
```

A room cannot be moved into maintenance while it is occupied.

A room under maintenance cannot be assigned during check-in.

---

# 34. API Response Principles

The API should return JSON responses.

Successful operations should provide:

* Operation status
* Relevant data
* Appropriate HTTP status code

Example:

```json
{
    "success": true,
    "message": "Room created successfully",
    "data": {
        "id": 101,
        "room_number": "101",
        "status": "AVAILABLE"
    }
}
```

Validation or authorization failures should return appropriate error responses.

Example:

```json
{
    "success": false,
    "message": "Room is not available for check-in"
}
```

---

# 35. HTTP Status Codes

The MVP should use standard HTTP status codes.

| Status | Usage                                 |
| ------ | ------------------------------------- |
| 200    | Successful read/update operation      |
| 201    | Successful creation                   |
| 400    | Invalid request or validation failure |
| 403    | Runtime role is not authorized        |
| 404    | Requested resource does not exist     |
| 409    | Business-state conflict               |
| 500    | Unexpected server error               |

---

# 36. Application Startup

`run.py` starts the Flask application.

Startup sequence:

```text
run.py
   ↓
Create Flask Application
   ↓
Load Configuration
   ↓
Initialize Runtime Data Store
   ↓
Load Initial Data
   ↓
Register Routes
   ↓
Start Flask
```

---

# 37. Application Dependency Structure

The complete dependency structure is:

```text
                  Flask Application
                         │
                         ▼
                       Routes
                         │
                         ▼
                      Services
                         │
                         ▼
                  Runtime Data Store
                         │
                         ▼
                Runtime Domain Classes
```

The dependency direction must remain:

```text
Routes → Services → Data Store
```

Services must not depend on routes.

The data store must not depend on routes.

Business logic must not be placed directly inside routes.

---

# 38. MVP Development Order

Development should proceed in the following order:

```text
Project Setup
      ↓
Flask Configuration
      ↓
Constants
      ↓
Runtime Data Store
      ↓
Hotel / Room Classes
      ↓
Initial Runtime Data
      ↓
Runtime Role Verification
      ↓
Room Management
      ↓
Room Types & Pricing
      ↓
Customer Check-in
      ↓
Customer Check-out
      ↓
Cleaning Management
      ↓
Dashboards
      ↓
Validation
      ↓
Error Handling
```

---

# 39. MVP Scope

The MVP includes:

* Flask API
* Runtime in-memory storage
* Owner role
* Reception role
* Cleaner role
* Runtime role verification
* Room management
* Room type management
* Pricing
* Room availability
* Maintenance
* Customer check-in
* Customer check-out
* Key-card generation
* Four-digit customer password generation
* Cleaning workflow
* Role-specific dashboards
* Backend validation
* JSON API responses

The MVP does not include:

* Frontend
* HTML
* CSS
* JavaScript frontend
* Persistent database
* ORM
* JWT
* Flask Session
* Cookies
* External authentication provider
* External services
* Persistent customer history
* Production-grade authentication
* Separate Data Model layer
* Separate authentication service
