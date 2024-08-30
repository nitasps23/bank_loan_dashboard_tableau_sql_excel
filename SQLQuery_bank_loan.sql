SELECT * FROM bank_loan_data;

-- 1. Bank loan applications
SELECT COUNT(id) AS total_loan_applications FROM bank_loan_data;

-- 2. MTD loan applications
SELECT COUNT(id) AS mtd_total_loan_applications FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 3. PMTD loan applications
SELECT COUNT(id) AS pmtd_total_loan_applications FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- to calculate MoM = (MTD-PMTD)/PMTD

-- 4. Total funded (loan) amount
SELECT SUM(loan_amount) AS total_funded_amount FROM bank_loan_data;

-- 5. MTD total loan amount
SELECT SUM(loan_amount) AS mtd_total_funded_amount FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 6. PMTD total loan amount
SELECT SUM(loan_amount) AS mtd_total_funded_amount FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 7. Total amount received (payment)
SELECT SUM(total_payment) AS total_amount_received FROM bank_loan_data;

-- 8. MTD amount received (payment)
SELECT SUM(total_payment) AS mtd_total_amount_received FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 9. PMTD amount received (payment)
SELECT SUM(total_payment) AS pmtd_total_amount_received FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 10. Average interest rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS avg_interest_rate FROM bank_loan_data;

-- 11. MTD Average interest rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS mtd_avg_interest_rate FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 12. PMTD Average interest rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS pmtd_avg_interest_rate FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- 13. Average debt-to-income ratio (DTI)
SELECT ROUND(AVG(dti), 4) * 100 AS avg_dti FROM bank_loan_data;

-- 14. MTD average debt-to-income ratio (DTI)
SELECT ROUND(AVG(dti), 4) * 100 AS mtd_avg_dti FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

-- 15. PMTD average debt-to-income ratio (DTI)
SELECT ROUND(AVG(dti), 4) * 100 AS pmtd_avg_dti FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021;

-- Good loan vs. Bad loan KPI’s

-- GOOD LOANS
-- 16. Good loan application percentage
SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/
	COUNT(id) AS good_loan_percentage
FROM bank_loan_data;

-- 17. Total number of good loan applications
SELECT COUNT(id) AS good_loan_applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- 18. Good loan funded amount
SELECT SUM(loan_amount) AS good_loan_funded_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- 19. Good loan total received amount
SELECT SUM(total_payment) AS good_loan_received_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';

-- BAD LOANS
-- 20. Bad loan application percentage
SELECT
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0)
	/
	COUNT(id) AS bad_loan_percentage
FROM bank_loan_data;

-- 21. Total number of bad loan applications
SELECT COUNT(id) AS bad_loan_applications FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- 22. Bad loan funded amount
SELECT SUM(loan_amount) AS bad_loan_funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off';

-- 23. Bad loan total received amount
SELECT SUM(total_payment) AS bad_loan_received_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- Loan status grid view
-- 24. Loan status
SELECT
	loan_status,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount,
	AVG(int_rate * 100) AS avg_interest_rate,
	AVG(dti * 100) AS dti
FROM bank_loan_data
GROUP BY loan_status;

-- 25. MTD loan status
SELECT
	loan_status,
	COUNT(id) AS mtd_total_loan_applications,
	SUM(total_payment) AS mtd_total_amount_received,
	SUM(loan_amount) AS mtd_total_funded_amount,
	AVG(int_rate * 100) AS mtd_avg_interest_rate,
	AVG(dti * 100) AS mtd_dti
FROM bank_loan_data
WHERE MONTH(issue_date) = 12
GROUP BY loan_status;


-- DASHBOARD #2
-- 26. Monthly trend by issue date
SELECT
	MONTH(issue_date) AS month_number,
	DATENAME(MONTH, issue_date) AS month_name,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);

-- 27. Regional analysis by state
SELECT
	address_state,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY address_state
ORDER BY COUNT(id) DESC;

-- 28. Loan term analysis
SELECT
	term,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY term
ORDER BY term;

-- 29. Employee length analysis
SELECT
	emp_length,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC;

-- 30. Loan purpose breakdown
SELECT
	purpose,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC;

-- 31. Homeownership analysis
SELECT
	home_ownership,
	COUNT(id) AS total_loan_applications,
	SUM(total_payment) AS total_amount_received,
	SUM(loan_amount) AS total_funded_amount
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

-- DASHBOARD #3 DETAILS
-- GRID WITH FILTER ON DASHBOARD
