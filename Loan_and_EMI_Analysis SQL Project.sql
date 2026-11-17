use finance_db;
select*from emi_information;
select * from loan_details;

-- (1) Write a query to find all loans where the loan amount is between ₹200,000 and ₹500,000, interest rate is greater than 12%, customer age is between 
-- 30 and 45 years, and the loan status is either 'Active' or 'Partially Paid', and the disbursement date is in the year 2022 or 2023.--  

select loan_amount,interest_rate,customer_age,loan_status,disbursement_date from loan_details  where loan_amount between 200000 and 500000
and  loan_amount between 200000 and 500000
and interest_rate > 12
and customer_age between 30 and 45 
and loan_status  IN ("Active" , "Partially Paid")
and year(disbursement_date) in (2022,2023);

-- 2)Retrieve loan records where the customer's credit score is below 650, annual income is less than ₹500,000, existing loans count is more than 2, default
--  history is 1, and the loan purpose is either 'Personal' or 'Debt Consolidation', and the processing fee percentage is above 2%. 
select credit_score,annual_income,existing_loans_count,default_history,loan_purpose,processing_fee_percent from loan_details 
where credit_score > 650 
and annual_income < 500000
and loan_purpose in ("Personal","Debt consolidation")
and existing_loans_count > 2
and default_history = 1 
and processing_fee_percent > 2 ;

-- 3) Find all EMI records where the late fee is greater than ₹100, the EMI status is 'Overdue', payment method
--  is either 'Cheque' or 'Cash', the EMI due date is in the first quarter of 2023 (Jan-Mar), and the total amount paid is less than the EMI amount. 
select i.late_fee,i.emi_status,i.payment_method,i.emi_due_date,i.total_amount_paid,d.emi_amount from emi_information i 
join loan_details d 
on d.loan_id = i.loan_id
where i.late_fee > 100
and i.payment_method in ("Cheque","Cash")
and i.emi_status = "pending"
and i.emi_due_date >= '2023-01-01' and i.emi_due_date < '2023-04-01'
and i.total_amount_paid > d.emi_amount;

-- 4)List all loans where the collateral type is 'Property' or '', collateral value is at least 1.5 times the loan amount, the customer
--  has insurance (has_insurance = 1), the bank name is either 'SBI' or 'HDFC', and the loan tenure is more than 60 months but less than 240 months. 
select collateral_type ,collateral_value,has_insurance,bank_name,loan_tenure_months from loan_details
where collateral_type in ("Property","Gold")
and collateral_value > 1.5 
and has_insurance = 1 
and bank_name in ("SBI","HDFC")
and loan_tenure_months between 60 and 240 ;

  -- 5 Retrieve EMI records where the bounce reason is not NULL, penalty charged is greater than ₹500, the EMI number is between 5 and 15, the
  -- outstanding principal after EMI is less than ₹100,000, and the payment method was 'Autodebit' but it bounced. 
select bounce_reason,penalty_charged,emi_number,outstanding_principal_after_emi,payment_method from emi_information
where  penalty_charged > 500 
and payment_method = "Autodebit"
and emi_number between 5 and 15
and bounce_reason is not null  
and outstanding_principal_after_emi < 100000;

-- 6)Find loans where the customer lives in a state that starts with 'M' or 'N', the city name contains 'pur' or 'abad', the pincode starts with '3' or '4',
 -- the country is 'India', and the employment type is either 'Salaried' or 'Professional' with annual income above ₹800,000 --

select state,city,pincode,country,employment_type,annual_income from loan_details 
where (state like 'M%' or state like 'N%')
and (city like '%pur%' or city like '%abad%')
and (pincode like '3%' or pincode like '4%')
and country = 'India'
and employment_type in ('Salaried','Professional')
and annual_income > 800000 ;


-- 7) List all loans where the processing fee amount is greater than ₹5,000, GST on processing fee is more than ₹900, the EMI bounce count is 0,
-- the is_npa flag is 0, and the loan was either approved within 10 days of application or disbursed within 5 days of approval --
 
select processing_fee_amount,gst_on_processing_fee,emi_bounce_count,is_npa,approval_date,application_date from loan_details 
where processing_fee_amount > 5000 
and gst_on_processing_fee > 900
and emi_bounce_count = 0
and is_npa = 0 
and  datediff(application_date,approval_date) <= 10 or datediff(application_date) <= 5 ;

-- 8) Retrieve EMI records where the transaction ID contains '5' and '8', the bank reference number starts with 'REF1', the payment date is after the due 
-- date by more than 7 days, the late fee is between ₹200 and ₹400, and the total amount paid includes the late fee. 

select transaction_id,bank_reference_number,emi_due_date,late_fee,total_amount_paid from emi_information 
where transaction_id like "%5%" and transaction_id like "%8%" 
and bank_reference_number like "REF1%"
and datediff(emi_due_date,emi_paid_date) > 7
and late_fee between 200 and 400
and total_amount_paid >=late_fee ;

-- 9)Find loans where the customer name contains two words, the email domain is 'gmail.com' or 'yahoo.com', the phone number starts with '9' or '8', 
-- the years in current job is more than 5 years, and the company name is not 'Self Employed'. 

select customer_name,customer_email,customer_phone,company_name,years_in_current_job from loan_details
where customer_email like "%gmail" or customer_email like "%yahoo.com"
and customer_phone like "9%" and customer_phone like "8%"
and years_in_current_job >= 5 
and company_name <> "Self Employed";


-- 10) List all EMI records where the principal component is greater than the interest component, the EMI number is odd, the EMI status is 'Paid', 
-- the created_at timestamp is from the year 2024, and the outstanding principal after EMI is more than 50% of the original loan amount. 
select i.principal_amount,i.interest_amount,i.emi_number,emi_status,i.created_at,i.outstanding_principal_after_emi,d.loan_amount from emi_information i 
join loan_details d 
on d.loan_id = i.loan_id 
where i.principal_amount > i.interest_amount
and i.emi_number % 2 = 1 
and i.emi_status = "Paid"
and i.created_at = 2024 
and i.outstanding_principal_after_emi > 50;


-- GROUP BY with HAVING Clause Questions (5 Questions)
-- 11)For each loan status category, find the count of loans, average loan amount, average interest rate, and total existing loan amount, but only include 
-- status categories where the average credit score is above 700 and the count of loans is more than 500

select count(*) as loan_status , avg(loan_amount) as avg_loan_amount,avg(interest_rate) as avg_interest_rate,sum(loan_amount) total_loan_amount
from loan_details 
where credit_score > 700 and loan_status > 500
group by loan_status,loan_amount,interest_rate,credit_score,loan_status;


-- 12) Group loans by bank name and employment type combination, calculate total loan amount disbursed, average processing fee percentage, and count of 
-- customers with default history, only showing groups where the total loan amount exceeds ₹50,000,000 and average interest rate is less than 12%. 
select bank_name,employment_type,
sum(loan_amount) as loan_amount ,
avg(processing_fee_percent) as processing_fee_percent,
count(customer_id)as customer_id  from loan_details
where interest_rate< 12 
group by bank_name, employment_type;

 -- 13)For each loan purpose and collateral type combination, find the maximum loan amount, minimum annual income, average credit score, and count of loans 
-- with insurance, but only include combinations where the average credit score is above 750 and the count of loans with collateral is more than 100.

select max(loan_amount) as max_loan_amount,
min(annual_income) as min_annual_income,
avg(credit_score)as avg_credit_score,
count(has_insurance) as count_has_insurance from loan_details
where credit_score >750 and collateral_value>100
group by loan_amount,annual_income,has_insurance,credit_score,collateral_value;

-- 14)Group EMI records by emi_status and payment_method, showing total amount paid, average late fee, count of bounced EMIs, and sum of penalty charged, 
-- only including groups where the total amount paid is greater than ₹10,000,000 and the average late fee is less than ₹150. 

select emi_status,payment_method,total_amount_paid,avg(late_fee) as avg_late_fee ,
count(is_emi_bounced) as count_is_emi_bounced,sum(penalty_charged) as sum_penalty_charged from emi_information
where total_amount_paid > 1000 and late_fee < 150
group by emi_status,payment_method,total_amount_paid;

-- 15)For each city and loan status combination, calculate the average loan amount, total annual income sum, average customer age, and count of defaulted 
-- loans, only showing groups where the average loan amount is above ₹250,000 and the count of loans is at least 50. 

select city,loan_status,
avg(loan_amount)as avg_loan_amount,sum(annual_income) as sum_annual_income,
avg(customer_age)as customer_age,count(default_history) as count_default_history from loan_details
group by city,loan_status
having avg(loan_amount) >250000 and count(*) <=50;


-- ORDER BY Based Questions (5 Questions) 

--  16)Write a query to list all active loans sorted first by credit score in descending order, then by loan amount in descending order, then by annual 
-- income ascending, and finally by customer age ascending, but only show the top 200 records. 
select credit_score,loan_amount,annual_income customer_age,annual_income from loan_details 
order by credit_score desc ,
loan_amount desc ,
annual_income asc ,
customer_age  asc limit 200;


-- 17) Retrieve all paid EMI records sorted by late fee descending, then by total amount paid descending, then by EMI due date ascending, then by transaction 
-- ID descending, and finally by created_at timestamp ascending. 
select late_fee, total_amount_paid,emi_due_date,transaction_id,emi_status from emi_information where emi_status = "paid"
order by late_fee desc,
total_amount_paid desc,
emi_due_date asc,
transaction_id desc ;

-- 18)List all defaulted loans sorted by total existing loan amount descending, then by default history descending, then by emi_bounce_count descending, 
-- then by processing fee amount ascending, and finally by loan tenure months descending. 
select loan_status,loan_amount,default_history,emi_bounce_count,processing_fee_amount,loan_tenure_months from loan_details where loan_status ="defaulted"
order by loan_amount desc,
default_history desc,
emi_bounce_count desc,
processing_fee_amount asc,
loan_tenure_months desc;
-- 19)Find all customers who have taken multiple loans, sorted first by existing loans count descending, then by total existing 
-- loan amount descending, then by annual income descending, then by customer age ascending, and finally by credit score ascending. 
select existing_loans_count,total_existing_loan_amount,annual_income,customer_age,credit_score from loan_details
order by existing_loans_count desc,
total_existing_loan_amount  desc,
annual_income desc,
customer_age asc ,
credit_score asc;

-- 20)Retrieve EMI records for loans with collateral, sorted by collateral value descending, then by loan amount descending, then by EMI number ascending, 
-- then by outstanding principal after EMI descending, and finally by penalty charged descending. 
 select d.collateral_value,d.loan_amount,i.emi_number,i.outstanding_principal_after_emi,i.penalty_charged from emi_information i 
 join loan_details d 
 on i.loan_id=d.loan_id
 where d.collateral_value is not null 
 order by d.collateral_value desc,
 d.loan_amount desc, 
 i.emi_number  asc ,
 i.outstanding_principal_after_emi desc ,
 i.penalty_charged desc;

  -- JOIN Based Questions with Multiple Conditions 
  
  -- 21 )Write a query joining loan_details and emi_information to find loans where the customer's credit score is below 650, the loan purpose is 
  -- 'Personal', at least 3 EMIs have been bounced (is_emi_bounced = 1), the total late fee collected exceeds ₹2,000, the average interest component
 --  per EMI is more than ₹500, and the loan status is 'Active'.
 
select d.loan_id,d.credit_score,d.loan_purpose,d.loan_status,sum(i.is_emi_bounced) as total_is_emi_bounced,avg(i.interest_amount) as avg_interest_amount,
sum(i.late_fee) as total_late_fee from loan_details d 
join emi_information i 
on i.loan_id = d.loan_id 
where d.credit_score < 650
and d.loan_purpose = 'Personal'
and d.loan_status = 'Active'
group by d.loan_id,d.credit_score,d.loan_purpose,d.loan_status
having sum(i.is_emi_bounced)>=3
and sum(i.late_fee) >2000
and avg(i.interest_amount)> 500;


-- 22)Create a query that shows loan performance metrics: loan_id, loan_amount, interest_rate, number of EMIs paid (using COUNT of emi_id),
--  number of EMIs bounced (SUM of is_emi_bounced), bounce rate (SUM(is_emi_bounced) * 100.0 / COUNT(emi_id)), and a risk category using CASE WHEN
 -- bounce_rate > 20 THEN 'High Risk' WHEN bounce_rate > 10 THEN 'Medium Risk' ELSE 'Low Risk' END. 
 SELECT
    loan_id,
    loan_amount,
    interest_rate,
    emi_count,
    bounced_emis,
    bounce_rate,

    CASE
        WHEN bounce_rate > 20 THEN 'High Risk'
        WHEN bounce_rate > 10 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category

FROM (
    SELECT
        l.loan_id,
        l.loan_amount,
        l.interest_rate,
        COUNT(e.emi_id) AS emi_count,
        COALESCE(SUM(e.is_emi_bounced), 0) AS bounced_emis,

        COALESCE(SUM(e.is_emi_bounced), 0)
        * 100.0 / NULLIF(COUNT(e.emi_id), 0) AS bounce_rate

    FROM loan_details l
    LEFT JOIN emi_information e
        ON l.loan_id = e.loan_id
    GROUP BY l.loan_id, l.loan_amount, l.interest_rate
) AS x;

-- 23 For each customer, display: customer_id, customer_name, UPPER(city) as city_upper, LENGTH(phone_number) as phone_digits, 
-- CONCAT(SUBSTRING(loan_id, 3, 4), '-', SUBSTRING(customer_id, 5, 4)) as custom_ref, and calculate the number of years between 
-- disbursement_date and today using DATEDIFF. 
  select customer_name,customer_phone ,upper(city) as city_upper ,length(customer_phone) as phone_gigits ,
CONCAT(
SUBSTRING(loan_id, 3, 4),
'-',
SUBSTRING(customer_id, 5, 4)
) AS custom_ref,
DATEDIFF(CURDATE(), disbursement_date) / 365 AS years_since_disbursement
from loan_details;

-- 24)Write a query to analyze customer segmentation: extract domain from email using SUBSTRING_INDEX, categorize age groups 
-- (CASE WHEN age < 30 THEN 'Young' WHEN age BETWEEN 30 AND 50 THEN 'Middle' ELSE 'Senior' END), calculate months since last EMI payment 
-- using DATEDIFF with MAX(emi_paid_date), and determine if the customer is active based on last payment being within 90 days.
 
 SELECT
    l.customer_id,
    l.customer_name,

    SUBSTRING_INDEX(l.customer_email, '@', -1)
        AS email_domain,

    CASE
        WHEN l.customer_age < 30 THEN 'Young'
        WHEN l.customer_age BETWEEN 30 AND 50 THEN 'Middle'
        ELSE 'Senior'
    END AS age_group,

    DATEDIFF(
        CURDATE(),
        MAX(e.emi_paid_date)
    ) / 30 AS months_since_last_payment,

    CASE
        WHEN DATEDIFF(CURDATE(), MAX(e.emi_paid_date)) <= 90
            THEN 'Active'
        ELSE 'Inactive'
    END AS customer_activity

FROM loan_details l
LEFT JOIN emi_information e
    ON l.loan_id = e.loan_id
GROUP BY
    l.customer_id,
    l.customer_name,
    l.customer_email,
    l.customer_age;
    
   -- For each loan, calculate: original tenure in days (loan_tenure_months * 30), actual repayment days (DATEDIFF(MAX(emi_paid_date),
   -- disbursement_date)), prepayment flag (CASE WHEN actual_repayment_days < original_tenure_days * 0.8 THEN 'Prepaid' ELSE 'Regular' END),
   -- interest saved percentage using ROUND, and format the loan_amount with commas using FORMAT.  
   
   SELECT
    l.loan_id,

    l.loan_tenure_months * 30
        AS original_tenure_days,

    DATEDIFF(
        MAX(e.emi_paid_date),
        l.disbursement_date
    ) AS actual_repayment_days,

    CASE
        WHEN DATEDIFF(
                MAX(e.emi_paid_date),
                l.disbursement_date
             ) < (l.loan_tenure_months * 30) * 0.8
            THEN 'Prepaid'
        ELSE 'Regular'
    END AS prepayment_flag,

    ROUND(
        (
            (l.loan_amount * l.interest_rate / 100)
            - COALESCE(SUM(e.interest_amount), 0)
        )
        /
        NULLIF(
            l.loan_amount * l.interest_rate / 100,
            0
        ) * 100,
        2
    ) AS interest_saved_percentage,

    FORMAT(l.loan_amount, 2) AS formatted_loan_amount

FROM loan_details l
LEFT JOIN emi_information e
    ON l.loan_id = e.loan_id
GROUP BY
    l.loan_id,
    l.loan_amount,
    l.interest_rate,
    l.loan_tenure_months,
    l.disbursement_date;

   
