# ALTADATA R Client

[ALTADATA](https://www.altadata.io) R package provides convenient access to the ALTADATA API from applications written in the R language.

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
client.get_header(product_code = PRODUCT_CODE)
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

### sort operation

```r
PRODUCT_CODE <- 'co_10_jhucs_03'

altadata.get_data(product_code = PRODUCT_CODE)
altadata.sort(order_column = "mortality_rate", order_method = "desc")
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

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/altabering/altadata-r/blob/master/LICENSE).