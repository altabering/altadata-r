# ALTADATA R Client

[![Build Actions status](https://github.com/altabering/altadata-r/workflows/build/badge.svg)](https://github.com/altabering/altadata-r/actions)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/altadata)](https://cran.r-project.org/package=altadata)

[ALTADATA](https://www.altadata.io) R package provides convenient access to the ALTADATA API from applications written in the R language. With this R package, developers can build applications around the ALTADATA API without having to deal with accessing and managing requests and responses.

## Installation

To install the [devtools](https://cran.r-project.org/package=devtools) package:

    install.packages("devtools")
    library(devtools)
    install_github("altabering/altadata-r")

To install the most recent package from CRAN type:

    install.packages("altadata")
    library(altadata)

## Quickstart

Obtain an API key in your dashboard and initialize the client:

```r
library(altadata)

aldatata.api_key('YOUR_API_KEY')
```

## Retrieving Data

You can get the entire data with the code below.

```r
altadata.get_data(product_code = 'PRODUCT_CODE')
data <- altadata.load()
```

## Retrieving Subscription Info

You can get your subscription info with the code below.

```r
subscription_info <- altadata.list_subscription()
```

## Retrieving Data Header Info

You can get your data header with the code below.

```r
header_info <- altadata.get_header(product_code = 'PRODUCT_CODE')
```

## Retrieving Data with Conditions

You can get data with using various conditions.

The columns you can apply these filter operations to are limited to the **filtered columns**.

> You can find the **filtered columns** in the data section of the data product page.

### equal condition

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.equal(condition_column = "province_state", condition_value = "Alabama")
data <- altadata.load()
```

### in condition

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.condition_in(condition_column = "province_state", condition_value = c("Utah", "Alabama"))
data <- altadata.load()
```

> condition_value parameter of condition_in method must be Array

### not in condition

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.condition_not_in(condition_column = "province_state", condition_value = c("Montana", "Utah", "Alabama"))
data <- altadata.load()
```

> condition_value parameter of condition_not_in method must be Array

### sort operation

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.sort(order_column = "reported_date", order_method = "asc")
data <- altadata.load()
```

> Default value of order_method parameter is 'asc' and order_method parameter must be 'asc' or 'desc'


### select specific columns

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.select(selected_columns = c("reported_date", "province_state", "population"))
data <- altadata.load()
```

> selected_column parameter of select method must be Array

### get the specified amount of data

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE, limit = 50)
data <- altadata.load()
```

## Retrieving Data with Multiple Conditions

You can use multiple condition at same time.

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.condition_in(condition_column = "province_state", condition_value = c("Utah", "Alabama"))
altadata.select(selected_columns = c("reported_date", "province_state", "population"))
data <- altadata.load()
```
