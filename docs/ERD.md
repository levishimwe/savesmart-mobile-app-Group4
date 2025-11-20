# SaveSmart - Entity Relationship Diagram (ERD)

## Database: Firestore NoSQL Database

### Collections and Data Structure

---

## 1. **users** Collection

Stores user profile information and authentication data.

### Fields:
| Field Name | Data Type | Required | Description |
|------------|-----------|----------|-------------|
| uid | String | Yes | Primary Key - Firebase Auth UID |
| email | String | Yes | User's email address |
| fullName | String | Yes | User's full name |
| phoneNumber | String | No | User's phone number (optional) |
| photoUrl | String | No | Profile picture URL |
| totalSavings | Number | Yes | Total amount saved across all goals (default: 0) |
| createdAt | Timestamp | Yes | Account creation timestamp |

### Indexes:
- `uid` (Primary Key)
- `email` (for queries)

### Example Document:
```json
{
  "uid": "abc123xyz",
  "email": "john@example.com",
  "fullName": "John Doe",
  "phoneNumber": "+1234567890",
  "photoUrl": "https://example.com/photo.jpg",
  "totalSavings": 3650.00,
  "createdAt": "2025-01-15T10:30:00Z"
}
```

---

## 2. **goals** Collection

Stores savings goals created by users.

### Fields:
| Field Name | Data Type | Required | Description |
|------------|-----------|----------|-------------|
| id | String | Yes | Primary Key - Auto-generated document ID |
| userId | String | Yes | Foreign Key → users.uid |
| name | String | Yes | Goal name (e.g., "New Laptop") |
| targetAmount | Number | Yes | Target amount to save |
| currentAmount | Number | Yes | Current saved amount (default: 0) |
| deadline | Timestamp | Yes | Goal completion deadline |
| createdAt | Timestamp | Yes | Goal creation timestamp |
| description | String | No | Optional goal description |
| category | String | No | Goal category (e.g., "Electronics", "Travel") |

### Indexes:
- `id` (Primary Key)
- `userId` (Foreign Key, indexed for queries)
- Compound index: `userId + createdAt` (for ordered user queries)

### Calculated Fields (in Entity):
- `progress`: Percentage of completion (currentAmount / targetAmount * 100)
- `isCompleted`: Boolean (currentAmount >= targetAmount)
- `daysRemaining`: Days until deadline

### Example Document:
```json
{
  "id": "goal001",
  "userId": "abc123xyz",
  "name": "New Laptop",
  "targetAmount": 1200.00,
  "currentAmount": 400.00,
  "deadline": "2025-06-30T00:00:00Z",
  "createdAt": "2025-01-01T00:00:00Z",
  "description": "MacBook Pro for development",
  "category": "Electronics"
}
```

---

## 3. **transactions** Collection

Stores financial transactions (deposits and expenses).

### Fields:
| Field Name | Data Type | Required | Description |
|------------|-----------|----------|-------------|
| id | String | Yes | Primary Key - Auto-generated document ID |
| userId | String | Yes | Foreign Key → users.uid |
| type | String | Yes | Transaction type: "expense" or "deposit" |
| amount | Number | Yes | Transaction amount |
| category | String | Yes | Transaction category |
| description | String | Yes | Transaction description |
| date | Timestamp | Yes | Transaction date |
| goalId | String | No | Foreign Key → goals.id (optional) |


### Indexes:
- `id` (Primary Key)
- `userId` (Foreign Key, indexed for queries)
- Compound index: `userId + date` (for date-range queries)
- `goalId` (indexed for goal-specific queries)

### Categories:
- **Expenses**: "Food", "Transport", "Shopping", "Bills", "Entertainment", "Other"
- **Deposits**: "Salary", "Gift", "Savings", "Other"

### Example Document:
```json
{
  "id": "trans001",
  "userId": "abc123xyz",
  "type": "expense",
  "amount": 45.50,
  "category": "Food",
  "description": "Grocery Store",
  "date": "2025-11-15T14:30:00Z",
  "goalId": null
}
```

---

## 4. **tips** Collection

Stores financial education tips and articles.

### Fields:
| Field Name | Data Type | Required | Description |
|------------|-----------|----------|-------------|
| id | String | Yes | Primary Key - Auto-generated document ID |
| title | String | Yes | Tip title |
| content | String | Yes | Tip content/body |
| category | String | Yes | Tip category |
| createdAt | Timestamp | Yes | Creation timestamp |
| orderIndex | Number | No | Display order (optional) |

### Categories:
- "Budgeting Basics"
- "Saving Strategies"
- "Student Finance"
- "Investment Tips"
- "Debt Management"

### Indexes:
- `id` (Primary Key)
- `category` (for filtered queries)
- `orderIndex` (for ordered display)

### Example Document:
```json
{
  "id": "tip001",
  "title": "Budgeting Basics",
  "content": "Learn how to create and manage an effective budget...",
  "category": "Budgeting",
  "createdAt": "2025-01-01T00:00:00Z",
  "orderIndex": 1
}
```

---

## Relationships

### One-to-Many Relationships:

1. **users → goals**
   - One user can have multiple goals
   - Foreign Key: `goals.userId` → `users.uid`

2. **users → transactions**
   - One user can have multiple transactions
   - Foreign Key: `transactions.userId` → `users.uid`

3. **goals → transactions** (Optional)
   - One goal can have multiple associated transactions
   - Foreign Key: `transactions.goalId` → `goals.id`

### Relationship Diagram:

```
┌─────────────┐
│    users    │
│             │
│  uid (PK)   │◄────────┐
│  email      │         │
│  fullName   │         │
│  ...        │         │
└─────────────┘         │
                        │
                        │ 1:N
                        │
      ┌─────────────────┴─────────────┐
      │                               │
      │                               │
┌─────▼──────┐                 ┌──────▼──────┐
│   goals    │                 │transactions │
│            │                 │             │
│  id (PK)   │◄──────┐         │  id (PK)    │
│  userId(FK)│       │         │  userId(FK) │
│  name      │       │ 1:N     │  type       │
│  ...       │       │         │  ...        │
└────────────┘       │         └─────────────┘
                     │
                     │
                ┌────┴────┐
                │  goalId │
                │   (FK)  │
                └─────────┘
```

---

## Security Rules Summary

All collections implement the following security:

1. **Authentication Required**: All operations require authenticated users
2. **Owner-Only Access**: Users can only access their own data
3. **Tips Exception**: All authenticated users can read tips; only admins can write

### Rules Applied:
- `users`: User can only read/write their own profile
- `goals`: User can only CRUD their own goals
- `transactions`: User can only CRUD their own transactions
- `tips`: All users can read; write restricted

---

## Data Integrity Constraints

1. **users.email**: Must be unique (enforced by Firebase Auth)
2. **goals.currentAmount**: Cannot exceed targetAmount (enforced by app logic)
3. **transactions.type**: Must be "expense" or "deposit"
4. **Foreign Keys**: userId must exist in users collection
5. **Amounts**: Must be positive numbers

---

## Indexes for Query Optimization

### Compound Indexes:
1. `goals`: (userId, createdAt DESC)
2. `transactions`: (userId, date DESC)
3. `transactions`: (userId, goalId)

These indexes optimize common queries:
- Get all user goals ordered by creation date
- Get user transactions in date range
- Get transactions for a specific goal

---

This ERD matches the actual Firestore implementation in the SaveSmart application.
