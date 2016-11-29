#### Capstone Project Overview

##### Lending for Financially Excluded Borrowers

1. What is the problem you want to solve?

  There has been a shift from traditional credit sources like banks to microlending or microcredit institutions especialy among individuals who find it hard to access bank loan facilities and small businesses. This category opts to find loans from such institutions to help them with their cash needs.

  My project has the following goals:

    - _For borrowers/Loanees_: Predict if a loan application will attract funding in full, or partially or none at all. how much loan amount their application may attract and optimize their loan application.
    - _For Partners_: Discover data insights that will help them understand their customers better and create a good customer experience for them by advising on their loan applications.

2. Who is your client and why do they care about this problem? In other words, what will your client DO or DECIDE based on your analysis that they wouldn’t otherwise?

  Gowee Inc, my client, is a field partner for Kiva, a major microfinance player. Study of the loans data may help them achieve the following:

  * To adequately advice borrowers on the possible success of getting funding for their loan applications.
  * Identify borrower profiles that mostly need the funding.
  * Identify industries or activities with greatest potential for social impact and group or segment their users based on that.

3. What data are you going to use for this? How will you acquire this data?

  I intend to use data from kiva.org accessible via their open api.

4. In brief, outline your approach to solving this problem (knowing that this might change later).

  * Acquire data
    - Script to connect to Api and pull data
  * Data cleaning
    - Check missing data.
    - Check data inconsistencies that may be generalized e.g business types
  * Data analysis
    - Check variables in the data set
    - Inspect for relationships between variables
    - Visualize the data
    - Pick most important variables that will help answer the problem(s)
  * Prediction
    - Train models for prediction
    - Check for models accuracies and choose the best one

5. What are your deliverables? Typically, this would include code, along with a paper and/or slide deck.

  * Code - R notebook
  * Presentation - slide deck

__Limitations of this dataset__:

The data set does not present enough information to enable:

- Predict profitability for the lenders.
- Predict success rate in loan repayment.

__Data variables__:
...
