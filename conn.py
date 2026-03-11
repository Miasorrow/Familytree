# #conn.py
# import mysql.connector
# import os
# from dotenv import load_dotenv

# load_dotenv()

# c = None

# def get_conn():
#     global c

#     if c is None or not c.is_connected():
#         c = mysql.connector.connect(
#             host=os.getenv("DB_HOST"),
#             user=os.getenv("DB_USER"),
#             password=os.getenv("DB_PASSWORD"),
#             database=os.getenv("DB_NAME"),
#             port=int(os.getenv("DB_PORT"))
#         )

#     return c


