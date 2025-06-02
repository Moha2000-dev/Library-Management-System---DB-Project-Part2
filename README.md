#  Library Management System – SQL Backend Project

This project simulates the backend of a library system, featuring database design, queries, procedures, functions, triggers, transactions, and reports to simulate real-world backend development.

---

##  Developer Reflection

### 1. What part was hardest and why?
The hardest part was implementing transactional consistency with proper rollback. Ensuring that all related updates (like loan creation and book availability) were handled atomically helped simulate real-world reliability. Debugging constraint violations and managing foreign key dependencies was also challenging.

### 2. Which concept helped you think like a backend developer?
Writing stored procedures, using triggers, and structuring transactions forced a mindset shift to backend logic. I had to think beyond individual queries and focus on system-wide behavior — especially for ensuring consistency, audit trails, and fail-safe operations.

### 3. How would you test this if it were a live web app?
- Wrap all transaction flows (borrow, return, payment) in RESTful API endpoints  
- Use tools like Postman or Swagger to simulate HTTP requests  
- Integrate frontend test cases to trigger real user scenarios  
- Use database test cases to verify state changes and rollbacks  
- Log all errors and rollback events for auditing  

---

##  Function Usage in Frontend

These SQL functions and procedures would be used in:

- **Member Profile** → View loan history, fines, and payment summaries  
- **Book Search Page** → Filter by genre, availability, or average rating  
- **Admin Dashboard** → Monitor revenue, occupancy rate, top reviewers  
- **Review & Rating Modules** → Display top books by user feedback  
- **Library Insights** → Analytics like most active branches and usage trends  

---

##  Modules Implemented

###  CRUD & Entity Relationships
- Book, Member, Loan, Library, Staff, Review, Payment

###  Views
- ViewAvailableBooks  
- ViewPopularBooks  
- ViewLoanStatusSummary

###  Stored Procedures
- sp_MarkBookUnavailable  
- sp_UpdateLoanStatus  
- sp_RankMembersByFines

###  Functions
- fn_GetBookAverageRating  
- fn_GetTopRatedBooks  
- fn_GetMemberLoanCount

###  Triggers
- trg_UpdateBookAvailability  
- trg_CalculateLibraryRevenue (print-only version)  
- trg_LoanDateValidation

###  Transactions
- Borrowing/returning a book  
- Registering a payment  
- Batch loan insert with rollback

###  Aggregation Reports
- Total fines per member  
- Most active libraries  
- Avg price per genre  
- Library revenue report  
- Top reviewed books

###  Advanced Analytics
- HAVING + subqueries  
- Occupancy rate calculation  
- Genres with high ratings  
- Members with loans but no fine

---

##  Testing Strategy

1. Insert seed data for books, members, payments, loans  
2. Run transactional flows to simulate real-world operations  
3. Query reports and views to verify expected results  
4. Test triggers and constraints by attempting invalid inserts  
5. Check rollback and error handling using TRY-CATCH  

---

This project simulates real backend architecture and helps build SQL fluency using professional best practices.
