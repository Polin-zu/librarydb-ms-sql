-- Создание базы данных LibraryDB
CREATE DATABASE [LibraryDB]
ON PRIMARY
( NAME = N'LibraryDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\LibraryDB.mdf' , SIZE = 10MB , FILEGROWTH = 1024KB )
LOG ON
( NAME = N'LibraryDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\LibraryDB_log.ldf' , SIZE = 10MB , FILEGROWTH = 10%)
GO
USE [LibraryDB]
GO