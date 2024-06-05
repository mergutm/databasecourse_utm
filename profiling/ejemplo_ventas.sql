
--
-- Table structure for table `Customers`
--

CREATE TABLE `Customers` (
  `CustomerID` int NOT NULL,
  `CustomerName` varchar(255) COLLATE utf32_bin DEFAULT NULL,
  `Email` varchar(255) COLLATE utf32_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_bin;

--
-- Dumping data for table `Customers`
--

INSERT INTO `Customers` (`CustomerID`, `CustomerName`, `Email`) VALUES
(101, 'John Doe', 'john@example.com'),
(102, 'Jane Smith', 'jane@example.com'),
(103, 'Bob Johnson', 'bob@example.com'),
(104, 'Alice Brown', 'alice@example.com');

-- --------------------------------------------------------

--
-- Table structure for table `Products`
--

CREATE TABLE `Products` (
  `ProductID` int NOT NULL,
  `ProductName` varchar(255) COLLATE utf32_bin DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_bin;

--
-- Dumping data for table `Products`
--

INSERT INTO `Products` (`ProductID`, `ProductName`, `Price`) VALUES
(1, 'Widget A', '10.00'),
(2, 'Gadget B', '15.00'),
(3, 'Widget C', '12.50');

-- --------------------------------------------------------

--
-- Table structure for table `SaleItems`
--

CREATE TABLE `SaleItems` (
  `SaleItemID` int NOT NULL,
  `SaleID` int DEFAULT NULL,
  `ProductID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_bin;

--
-- Dumping data for table `SaleItems`
--

INSERT INTO `SaleItems` (`SaleItemID`, `SaleID`, `ProductID`, `Quantity`, `Price`) VALUES
(1, 1, 1, 2, '10.00'),
(2, 1, 3, 1, '12.50'),
(3, 2, 2, 1, '15.00'),
(4, 3, 1, 3, '10.00'),
(5, 3, 2, 2, '15.00'),
(6, 4, 2, 1, '15.00'),
(7, 4, 3, 2, '12.50'),
(8, 5, 3, 1, '12.50');

-- --------------------------------------------------------

--
-- Table structure for table `Sales`
--

CREATE TABLE `Sales` (
  `SaleID` int NOT NULL,
  `CustomerID` int DEFAULT NULL,
  `SaleDate` date DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_bin;

--
-- Dumping data for table `Sales`
--

INSERT INTO `Sales` (`SaleID`, `CustomerID`, `SaleDate`, `TotalAmount`) VALUES
(1, 101, '2024-06-01', '32.50'),
(2, 102, '2024-06-02', '15.00'),
(3, 103, '2024-06-03', '60.00'),
(4, 101, '2024-06-04', '40.00'),
(5, 104, '2024-06-05', '12.50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Customers`
--
ALTER TABLE `Customers`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `Products`
--
ALTER TABLE `Products`
  ADD PRIMARY KEY (`ProductID`);

--
-- Indexes for table `SaleItems`
--
ALTER TABLE `SaleItems`
  ADD PRIMARY KEY (`SaleItemID`),
  ADD KEY `SaleID` (`SaleID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `Sales`
--
ALTER TABLE `Sales`
  ADD PRIMARY KEY (`SaleID`),
  ADD KEY `CustomerID` (`CustomerID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `SaleItems`
--
ALTER TABLE `SaleItems`
  ADD CONSTRAINT `SaleItems_ibfk_1` FOREIGN KEY (`SaleID`) REFERENCES `Sales` (`SaleID`),
  ADD CONSTRAINT `SaleItems_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `Products` (`ProductID`);

--
-- Constraints for table `Sales`
--

ALTER TABLE `Sales`
  ADD CONSTRAINT `Sales_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `Customers` (`CustomerID`);
COMMIT;

