# COVID-19, the Stock Market & Unemployment
# YU DAV 6100 Group 3 Final Project

In this project we are interesting in analyzing the relationship between COVID-19 cases in the U.S., the average performance of the S&P 500, and unemployment over time.

To do so, we will combine data sources from the New York Times public GitHub Repository, use the FRED API through pandas in Python, and utilize free data published by the United States Department of Labor. After preparing the data in Python, we will load the data into a MySQL cloud instance utilizing AWS RDS, and then connect this data in Tableau to create visualizations and insights. 

## Design & Planning

### Bus Matrix
To begin, we brainstormed what data we wanted to include. We then created a bus matrix (this can be viewed in this repository, it is the document titled "Group_3_Final_Project_Bus_Matrix."

### Use Case
We then put together a basic use case which is pasted immediately below as well as saved in the above repository, the document is titled "use."
Use Case

The goal of this project is to provide updated information on unemployment, stock prices, and the number of cases and deaths in the United States by state and week. 

Our solution will be useful to different kinds of users. Firstly, this information could be used by investors, should there be another pandemic, to help predict when the stock crash would happen. Secondly, it could be used by economic analysts outside of buying stocks to help predict costs due to unemployment or otherwise understand the potential impact of a pandemic. Thirdly, city, state, and government officials could use this information to help understand growth rate of the virus, understand how many supplies they may need, or see where in the country the virus is spreading. This could help with supply chain management. 

### Dimensional Model

In addition to being located in our repository above, the dimensional model can be seen here:
![Here is our dimensional model](https://github.com/sarahb26/GROUP3/blob/master/Dimensional%20Model%205.20.20.JPG)


### Conceptual Architecure

In addition to being located in our repository above, the conceptual architecture can be seen here.
We prepared all of the data from the different sources in python, uploaded to staging tables in a MySQL cloud instance using Amazon Web Services RDS. We then connected Tableau to this database through RDS and created our insights and visualizations there. 

![Here is our conceptual architecture](https://github.com/sarahb26/GROUP3/blob/master/Conceptual%20Architecture.jpg)

### Project Waterfall

Our project waterfall shows the overall path to completion for our project and can be located in our repository in the file called "Waterfall." 

## Development of the Warehouse Solution

The development of our warehouse solution started with gathering the data and preparing it in Python to be inserted into staging tables in an AWS RDS instance of MySQL.

```
There are three files in the repository, titled "NYT Coronavirus Data to SQL - 5.20.20", "S&P 500 Daily", and "Unemployment" that were used for this purpose. The last box of code in each uploads the code directly into the MySQL instance. You first have to create an empty database in MySQL called "stock_data" with a simple "CREATE DATABASE stock_data;" statement. Then run the python files and they will insert the tables into your database. After running the python files, click the refresh button on the left hand side and see if your data loaded correctly. 
```

Next we had to create the additional tables, date, and location in our "stock_data" database in order to create the dimensional model.

```
There are 2 files that were used for this purpose in our repository. They are titled "date_table-1", and "location_table." These files were created in Excel using formulas and added to SQL to create the date and location tables which will be used in the dimensional model.
```
Next, we had to create our dimensional model and create the script to load the information from our staging tables into the data warehouse.

```
There are two scripts for this process. The script to create the dimensional model is called "fact_table_RLW" and needs to be run before you can load the data into the warehouse. The script to update the tables is in the file titled "update_script_RLW". 
```

Lastly, after the dimensional model and database have been created, we connected Tableau to our RDS instance and then created our visualizations.

## Visualizations

Our visualizations were created in Tableau. We have saved a copy of the Tableau file with a data extract in our repository, and have pasted below a link to the Tableau Public visualization:

* [Visualization](https://public.tableau.com/profile/rachel.ward3031#!/vizhome/UnitedStatesCovid19UnemploymenttheStockMarket/Dashboard?publish=yes)

## Presentation

We presented our project in our final class meeting, our presentation can be found in the repository in the file called "COVID-19 and the Stock Market."


## Authors
Sarah Bismuth, Rachel Ward, Zhihong Zhang, Zhijing Zhang


## Acknowledgments

* Thank you to our Professor, Brandon Chiazza for his help and guidance throughout this project.
* Thank you also to Jacob Goodman, TA for our class for stepping up in a difficult time to help our class.
* Lastly, thank you to Sara Ferrari for last minute SQL Guidance!
