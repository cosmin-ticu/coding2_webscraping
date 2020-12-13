library(rvest)
require(httr)
library(jsonlite)
library(data.table)
library(dplyr)
library(purrr)

headers = c(
  `authority` = 'www.forbes.com',
  `accept` = 'application/json, text/plain, */*',
  `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
  `sec-fetch-site` = 'same-origin',
  `sec-fetch-mode` = 'cors',
  `sec-fetch-dest` = 'empty',
  `referer` = 'https://www.forbes.com/global2000/',
  `accept-language` = 'en-US,en;q=0.9,nl-NL;q=0.8,nl;q=0.7,ro;q=0.6',
  `cookie` = 'client_id=647bb8b510c48fa574e8d90c6504a63c27a; notice_gdpr_prefs=0,1,2:1a8b5228dd7ff0717196863a5d28ce6c; notice_preferences=2:1a8b5228dd7ff0717196863a5d28ce6c; _cb_ls=1; _cb=DRZrudBn4kTnlNJhs; _ga=GA1.2.1949116926.1590076935; __qca=P0-1353362192-1590076935949; _sp_id.986d=62222acfa7daaf29.1590076947.1.1590076947.1590076947.95197e53-9c63-4ac1-8fcd-e7af1a3a90ed; xdibx=N4Ig-mBGAeDGCuAnRIBcoAOGAuBnNAjAKwCcADGQOyVkEAcAbCXQDQgYBusAdtmgMxtc-VMXJUm.SkQAsRNp1w8-qQSERIANmhAALbNgy5UAehMB3SwDoA5gHs7NzQFMrsOwFsTINpq06TXABLbGdcEw9YAGsg7lxnAE8TACZafhMqFOSTSCCbAFoAEwBDbGL84u5izQTsINhcCu5C.OxdZ3yAM3hsJA67TvyPYsQo5zruAtxqsJMAYgJYAhJIQpk5IjpKHxBNPEJSCmpaRmYAXzYIGAxEZw40UBKEkQBtMSPJaRk6AF0L8Cg0Duzl4ImA.yucCChR0ZCIcNgJAYBHyMkKTFRJRkFTInToXVg.DonUg0kohUo5XeEhI.AYREoJBAZyAA; global_ad_params=%7B%7D; _fbp=fb.1.1605636636370.1262455748; __pnahc=0; crdl_forbes-liveaID=anonimE51xjoe3Tw0agQZFs6Fg; __tbc=%7Bjzx%7DIFcj-ZhxuNCMjI4-mDfH1CHTvL0kM8d1ab-adQgGNVqzJhRJrPOfki8Uo7zMn7aS_UL_VMD3Cf_r1iiBnxs3AJL9UCjSeEjl4C4rfTZVk8nat3iND8BKF1_5vNQWEzEV3E9l5ifC0NcYbET3aSZxuA; __pat=-18000000; gaWelcomPageTracked=true; notice_behavior=expressed,eu; __aaxsc=0; AMP_TOKEN=%24NOT_FOUND; _gid=GA1.2.43326704.1607770680; rbzid=H714dWPhsfoL6pnOp0LYW+5hhxDAkzHYXnYK9hDGPopzUEuKVIjeza+chqWzKtYbx219oNlZ0tDHyGyyDvy4mE4afTFJ1aQHq8QvHzIPhq/7/vdeuDYX3nGDfFqmrjE769OYyfZ0TJFFH4BBM/468+HP+t3vK6XgvxeaXcV1+6FnkQ17IWP+epxfXAKenPaFmvys80CIIuAqAa0V44bUwvjW+3HvcHt0vlK7Dz/ujKU65s+agFerSV2CyULK5LVRmppaXnIXyJHp7MkrMFK/mQ==; rbzsessionid=255e2d0fd7c973e24deefaee113d0b1c; _cb_svref=null; __gads=ID=7bf153004501cb72:T=1607770730:R:S=ALNI_MbfwjnkkDJ88jUiBs-vUe851_1k9g; aasd=2%7C1607770679880; _dc_gtm_UA-5883199-3=1; _gat_UA-5883199-3=1; __pvi=%7B%22id%22%3A%22v-2020-12-12-12-58-00-193-Nt2ZQlcFqpqljQrK-ae1c1dcf203be31b4dbc42657e81bf7e%22%2C%22domain%22%3A%22.forbes.com%22%2C%22time%22%3A1607770746128%7D; __adblocker=false; xbc=%7Bjzx%7DKdQdrBxJ3eczRFL5k3BVTghnCXYsqI3yMu3H3SVN1DtrlLuSvyYEc4SMBqlsNDAT7w6lTPpGwdl5vp-H2szndAlCMRzmz0W95t7m5VeT56lcLdhT5VORB_KNB5IlreZrTO9OY2pFNYOyMaZ74b2pzRjYPG-FoRMuY1jXlYqOM8hTluf3MXvFNPTRbN47P0bKpnb0U6GT3w-UXsXgyVZPGm7THSKXBVuzcAiG9w5zHrsiQNiN0oDLjVUqSm8GI_ZTzQ6g-58hNU48OUcziCcsWMcAsodzh98W7RWGjgJov7fZVfjxKTqzNyiAtlpKft_-; _chartbeat2=.1590076934733.1607770749770.0000000000000001.Bv_jvLCsgxBgBrES30BYKLrsa451G.2; QSI_HistorySession=https%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%237ac9a205335d~1607770684517%7Chttps%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%23295aa3b7335d~1607770749825; _chartbeat4=t=qJcC1KrFWu5aWrqDdNx7QptOT4&E=5&x=0&c=0.16&y=11294&w=1010; session_depth=www.forbes.com%3D3%7C462705817%3D3%7C383070046%3D3%7C823003578%3D3%7C659093976%3D3%7C218291818%3D3; mnet_session_depth=3%7C1607770679072'
)

params = list(
  `limit` = '2000'
)

res <- httr::GET(url = 'https://www.forbes.com/forbesapi/org/global2000/2019/position/true.json', httr::add_headers(.headers=headers), query = params)

#NB. Original query string below. It seems impossible to parse and
#reproduce query strings 100% accurately so the one below is given
#in case the reproduced version is not "correct".
# res <- httr::GET(url = 'https://www.forbes.com/forbesapi/org/global2000/2020/position/true.json?limit=2000', httr::add_headers(.headers=headers))

df <- fromJSON(content(res, 'text'))

x <- df$organizationList$organizationsLists


# Function to get company data on one year --------------------------------

get_forbes_data <- function(year){
  
  headers = c(
    `authority` = 'www.forbes.com',
    `accept` = 'application/json, text/plain, */*',
    `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    `sec-fetch-site` = 'same-origin',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `referer` = 'https://www.forbes.com/global2000/',
    `accept-language` = 'en-US,en;q=0.9,nl-NL;q=0.8,nl;q=0.7,ro;q=0.6',
    `cookie` = 'client_id=647bb8b510c48fa574e8d90c6504a63c27a; notice_gdpr_prefs=0,1,2:1a8b5228dd7ff0717196863a5d28ce6c; notice_preferences=2:1a8b5228dd7ff0717196863a5d28ce6c; _cb_ls=1; _cb=DRZrudBn4kTnlNJhs; _ga=GA1.2.1949116926.1590076935; __qca=P0-1353362192-1590076935949; _sp_id.986d=62222acfa7daaf29.1590076947.1.1590076947.1590076947.95197e53-9c63-4ac1-8fcd-e7af1a3a90ed; xdibx=N4Ig-mBGAeDGCuAnRIBcoAOGAuBnNAjAKwCcADGQOyVkEAcAbCXQDQgYBusAdtmgMxtc-VMXJUm.SkQAsRNp1w8-qQSERIANmhAALbNgy5UAehMB3SwDoA5gHs7NzQFMrsOwFsTINpq06TXABLbGdcEw9YAGsg7lxnAE8TACZafhMqFOSTSCCbAFoAEwBDbGL84u5izQTsINhcCu5C.OxdZ3yAM3hsJA67TvyPYsQo5zruAtxqsJMAYgJYAhJIQpk5IjpKHxBNPEJSCmpaRmYAXzYIGAxEZw40UBKEkQBtMSPJaRk6AF0L8Cg0Duzl4ImA.yucCChR0ZCIcNgJAYBHyMkKTFRJRkFTInToXVg.DonUg0kohUo5XeEhI.AYREoJBAZyAA; global_ad_params=%7B%7D; _fbp=fb.1.1605636636370.1262455748; __pnahc=0; crdl_forbes-liveaID=anonimE51xjoe3Tw0agQZFs6Fg; __tbc=%7Bjzx%7DIFcj-ZhxuNCMjI4-mDfH1CHTvL0kM8d1ab-adQgGNVqzJhRJrPOfki8Uo7zMn7aS_UL_VMD3Cf_r1iiBnxs3AJL9UCjSeEjl4C4rfTZVk8nat3iND8BKF1_5vNQWEzEV3E9l5ifC0NcYbET3aSZxuA; __pat=-18000000; gaWelcomPageTracked=true; notice_behavior=expressed,eu; __aaxsc=0; AMP_TOKEN=%24NOT_FOUND; _gid=GA1.2.43326704.1607770680; rbzid=H714dWPhsfoL6pnOp0LYW+5hhxDAkzHYXnYK9hDGPopzUEuKVIjeza+chqWzKtYbx219oNlZ0tDHyGyyDvy4mE4afTFJ1aQHq8QvHzIPhq/7/vdeuDYX3nGDfFqmrjE769OYyfZ0TJFFH4BBM/468+HP+t3vK6XgvxeaXcV1+6FnkQ17IWP+epxfXAKenPaFmvys80CIIuAqAa0V44bUwvjW+3HvcHt0vlK7Dz/ujKU65s+agFerSV2CyULK5LVRmppaXnIXyJHp7MkrMFK/mQ==; rbzsessionid=255e2d0fd7c973e24deefaee113d0b1c; _cb_svref=null; __gads=ID=7bf153004501cb72:T=1607770730:R:S=ALNI_MbfwjnkkDJ88jUiBs-vUe851_1k9g; aasd=2%7C1607770679880; _dc_gtm_UA-5883199-3=1; _gat_UA-5883199-3=1; __pvi=%7B%22id%22%3A%22v-2020-12-12-12-58-00-193-Nt2ZQlcFqpqljQrK-ae1c1dcf203be31b4dbc42657e81bf7e%22%2C%22domain%22%3A%22.forbes.com%22%2C%22time%22%3A1607770746128%7D; __adblocker=false; xbc=%7Bjzx%7DKdQdrBxJ3eczRFL5k3BVTghnCXYsqI3yMu3H3SVN1DtrlLuSvyYEc4SMBqlsNDAT7w6lTPpGwdl5vp-H2szndAlCMRzmz0W95t7m5VeT56lcLdhT5VORB_KNB5IlreZrTO9OY2pFNYOyMaZ74b2pzRjYPG-FoRMuY1jXlYqOM8hTluf3MXvFNPTRbN47P0bKpnb0U6GT3w-UXsXgyVZPGm7THSKXBVuzcAiG9w5zHrsiQNiN0oDLjVUqSm8GI_ZTzQ6g-58hNU48OUcziCcsWMcAsodzh98W7RWGjgJov7fZVfjxKTqzNyiAtlpKft_-; _chartbeat2=.1590076934733.1607770749770.0000000000000001.Bv_jvLCsgxBgBrES30BYKLrsa451G.2; QSI_HistorySession=https%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%237ac9a205335d~1607770684517%7Chttps%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%23295aa3b7335d~1607770749825; _chartbeat4=t=qJcC1KrFWu5aWrqDdNx7QptOT4&E=5&x=0&c=0.16&y=11294&w=1010; session_depth=www.forbes.com%3D3%7C462705817%3D3%7C383070046%3D3%7C823003578%3D3%7C659093976%3D3%7C218291818%3D3; mnet_session_depth=3%7C1607770679072'
  )
  
  params = list(
    `limit` = '2000'
  )
  
  res <- httr::GET(url = paste0('https://www.forbes.com/forbesapi/org/global2000/',year,'/position/true.json'), httr::add_headers(.headers=headers), query = params)
    
  df <- fromJSON(content(res, 'text'))
    
  findf <- data.table(df$organizationList$organizationsLists) %>% transmute(year, month, description, rank, 
                                                                         organization.name, industry, country, 
                                                                        revenue, profits, assets, marketValue, 
                                                                        profitsRank, assetsRank, marketValueRank,
                                                                        ceoName, city, yearFounded)
  
  return(findf)
  
}

trial <- get_forbes_data(2011)


# Define range of years to get company data -------------------------------

years <- c(2010:2020)

all_forbes_data <- rbindlist(
  lapply(years, get_forbes_data), fill = T
)


# Get and prepare data for Racing Bar Chart -------------------------------

get_forbes_racing_data <- function(year_choice){
  
  headers = c(
    `authority` = 'www.forbes.com',
    `accept` = 'application/json, text/plain, */*',
    `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    `sec-fetch-site` = 'same-origin',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `referer` = 'https://www.forbes.com/global2000/',
    `accept-language` = 'en-US,en;q=0.9,nl-NL;q=0.8,nl;q=0.7,ro;q=0.6',
    `cookie` = 'client_id=647bb8b510c48fa574e8d90c6504a63c27a; notice_gdpr_prefs=0,1,2:1a8b5228dd7ff0717196863a5d28ce6c; notice_preferences=2:1a8b5228dd7ff0717196863a5d28ce6c; _cb_ls=1; _cb=DRZrudBn4kTnlNJhs; _ga=GA1.2.1949116926.1590076935; __qca=P0-1353362192-1590076935949; _sp_id.986d=62222acfa7daaf29.1590076947.1.1590076947.1590076947.95197e53-9c63-4ac1-8fcd-e7af1a3a90ed; xdibx=N4Ig-mBGAeDGCuAnRIBcoAOGAuBnNAjAKwCcADGQOyVkEAcAbCXQDQgYBusAdtmgMxtc-VMXJUm.SkQAsRNp1w8-qQSERIANmhAALbNgy5UAehMB3SwDoA5gHs7NzQFMrsOwFsTINpq06TXABLbGdcEw9YAGsg7lxnAE8TACZafhMqFOSTSCCbAFoAEwBDbGL84u5izQTsINhcCu5C.OxdZ3yAM3hsJA67TvyPYsQo5zruAtxqsJMAYgJYAhJIQpk5IjpKHxBNPEJSCmpaRmYAXzYIGAxEZw40UBKEkQBtMSPJaRk6AF0L8Cg0Duzl4ImA.yucCChR0ZCIcNgJAYBHyMkKTFRJRkFTInToXVg.DonUg0kohUo5XeEhI.AYREoJBAZyAA; global_ad_params=%7B%7D; _fbp=fb.1.1605636636370.1262455748; __pnahc=0; crdl_forbes-liveaID=anonimE51xjoe3Tw0agQZFs6Fg; __tbc=%7Bjzx%7DIFcj-ZhxuNCMjI4-mDfH1CHTvL0kM8d1ab-adQgGNVqzJhRJrPOfki8Uo7zMn7aS_UL_VMD3Cf_r1iiBnxs3AJL9UCjSeEjl4C4rfTZVk8nat3iND8BKF1_5vNQWEzEV3E9l5ifC0NcYbET3aSZxuA; __pat=-18000000; gaWelcomPageTracked=true; notice_behavior=expressed,eu; __aaxsc=0; AMP_TOKEN=%24NOT_FOUND; _gid=GA1.2.43326704.1607770680; rbzid=H714dWPhsfoL6pnOp0LYW+5hhxDAkzHYXnYK9hDGPopzUEuKVIjeza+chqWzKtYbx219oNlZ0tDHyGyyDvy4mE4afTFJ1aQHq8QvHzIPhq/7/vdeuDYX3nGDfFqmrjE769OYyfZ0TJFFH4BBM/468+HP+t3vK6XgvxeaXcV1+6FnkQ17IWP+epxfXAKenPaFmvys80CIIuAqAa0V44bUwvjW+3HvcHt0vlK7Dz/ujKU65s+agFerSV2CyULK5LVRmppaXnIXyJHp7MkrMFK/mQ==; rbzsessionid=255e2d0fd7c973e24deefaee113d0b1c; _cb_svref=null; __gads=ID=7bf153004501cb72:T=1607770730:R:S=ALNI_MbfwjnkkDJ88jUiBs-vUe851_1k9g; aasd=2%7C1607770679880; _dc_gtm_UA-5883199-3=1; _gat_UA-5883199-3=1; __pvi=%7B%22id%22%3A%22v-2020-12-12-12-58-00-193-Nt2ZQlcFqpqljQrK-ae1c1dcf203be31b4dbc42657e81bf7e%22%2C%22domain%22%3A%22.forbes.com%22%2C%22time%22%3A1607770746128%7D; __adblocker=false; xbc=%7Bjzx%7DKdQdrBxJ3eczRFL5k3BVTghnCXYsqI3yMu3H3SVN1DtrlLuSvyYEc4SMBqlsNDAT7w6lTPpGwdl5vp-H2szndAlCMRzmz0W95t7m5VeT56lcLdhT5VORB_KNB5IlreZrTO9OY2pFNYOyMaZ74b2pzRjYPG-FoRMuY1jXlYqOM8hTluf3MXvFNPTRbN47P0bKpnb0U6GT3w-UXsXgyVZPGm7THSKXBVuzcAiG9w5zHrsiQNiN0oDLjVUqSm8GI_ZTzQ6g-58hNU48OUcziCcsWMcAsodzh98W7RWGjgJov7fZVfjxKTqzNyiAtlpKft_-; _chartbeat2=.1590076934733.1607770749770.0000000000000001.Bv_jvLCsgxBgBrES30BYKLrsa451G.2; QSI_HistorySession=https%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%237ac9a205335d~1607770684517%7Chttps%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%23295aa3b7335d~1607770749825; _chartbeat4=t=qJcC1KrFWu5aWrqDdNx7QptOT4&E=5&x=0&c=0.16&y=11294&w=1010; session_depth=www.forbes.com%3D3%7C462705817%3D3%7C383070046%3D3%7C823003578%3D3%7C659093976%3D3%7C218291818%3D3; mnet_session_depth=3%7C1607770679072'
  )
  
  params = list(
    `limit` = '2000'
  )
  
  res <- httr::GET(url = paste0('https://www.forbes.com/forbesapi/org/global2000/',year_choice,'/position/true.json'), httr::add_headers(.headers=headers), query = params)
  
  df <- fromJSON(content(res, 'text'))
  
  findf <- data.table(df$organizationList$organizationsLists) %>% transmute(uri, marketValue)
  
  names(findf)[2] <- paste0('marketValue_',year_choice)
  
  return(findf)  
}

test <- get_forbes_racing_data(2019)

list_along_forbes_years <- cbind(
  lapply(years, get_forbes_racing_data)
)

forbes_years_racingChart_data <- list_along_forbes_years %>% reduce(right_join, by = c("uri") )


# Get and prepare country and industry data for racing bar chart ----------

get_forbes_extra_racing_data <- function(year_choice = 2020){
  
  headers = c(
    `authority` = 'www.forbes.com',
    `accept` = 'application/json, text/plain, */*',
    `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36',
    `sec-fetch-site` = 'same-origin',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `referer` = 'https://www.forbes.com/global2000/',
    `accept-language` = 'en-US,en;q=0.9,nl-NL;q=0.8,nl;q=0.7,ro;q=0.6',
    `cookie` = 'client_id=647bb8b510c48fa574e8d90c6504a63c27a; notice_gdpr_prefs=0,1,2:1a8b5228dd7ff0717196863a5d28ce6c; notice_preferences=2:1a8b5228dd7ff0717196863a5d28ce6c; _cb_ls=1; _cb=DRZrudBn4kTnlNJhs; _ga=GA1.2.1949116926.1590076935; __qca=P0-1353362192-1590076935949; _sp_id.986d=62222acfa7daaf29.1590076947.1.1590076947.1590076947.95197e53-9c63-4ac1-8fcd-e7af1a3a90ed; xdibx=N4Ig-mBGAeDGCuAnRIBcoAOGAuBnNAjAKwCcADGQOyVkEAcAbCXQDQgYBusAdtmgMxtc-VMXJUm.SkQAsRNp1w8-qQSERIANmhAALbNgy5UAehMB3SwDoA5gHs7NzQFMrsOwFsTINpq06TXABLbGdcEw9YAGsg7lxnAE8TACZafhMqFOSTSCCbAFoAEwBDbGL84u5izQTsINhcCu5C.OxdZ3yAM3hsJA67TvyPYsQo5zruAtxqsJMAYgJYAhJIQpk5IjpKHxBNPEJSCmpaRmYAXzYIGAxEZw40UBKEkQBtMSPJaRk6AF0L8Cg0Duzl4ImA.yucCChR0ZCIcNgJAYBHyMkKTFRJRkFTInToXVg.DonUg0kohUo5XeEhI.AYREoJBAZyAA; global_ad_params=%7B%7D; _fbp=fb.1.1605636636370.1262455748; __pnahc=0; crdl_forbes-liveaID=anonimE51xjoe3Tw0agQZFs6Fg; __tbc=%7Bjzx%7DIFcj-ZhxuNCMjI4-mDfH1CHTvL0kM8d1ab-adQgGNVqzJhRJrPOfki8Uo7zMn7aS_UL_VMD3Cf_r1iiBnxs3AJL9UCjSeEjl4C4rfTZVk8nat3iND8BKF1_5vNQWEzEV3E9l5ifC0NcYbET3aSZxuA; __pat=-18000000; gaWelcomPageTracked=true; notice_behavior=expressed,eu; __aaxsc=0; AMP_TOKEN=%24NOT_FOUND; _gid=GA1.2.43326704.1607770680; rbzid=H714dWPhsfoL6pnOp0LYW+5hhxDAkzHYXnYK9hDGPopzUEuKVIjeza+chqWzKtYbx219oNlZ0tDHyGyyDvy4mE4afTFJ1aQHq8QvHzIPhq/7/vdeuDYX3nGDfFqmrjE769OYyfZ0TJFFH4BBM/468+HP+t3vK6XgvxeaXcV1+6FnkQ17IWP+epxfXAKenPaFmvys80CIIuAqAa0V44bUwvjW+3HvcHt0vlK7Dz/ujKU65s+agFerSV2CyULK5LVRmppaXnIXyJHp7MkrMFK/mQ==; rbzsessionid=255e2d0fd7c973e24deefaee113d0b1c; _cb_svref=null; __gads=ID=7bf153004501cb72:T=1607770730:R:S=ALNI_MbfwjnkkDJ88jUiBs-vUe851_1k9g; aasd=2%7C1607770679880; _dc_gtm_UA-5883199-3=1; _gat_UA-5883199-3=1; __pvi=%7B%22id%22%3A%22v-2020-12-12-12-58-00-193-Nt2ZQlcFqpqljQrK-ae1c1dcf203be31b4dbc42657e81bf7e%22%2C%22domain%22%3A%22.forbes.com%22%2C%22time%22%3A1607770746128%7D; __adblocker=false; xbc=%7Bjzx%7DKdQdrBxJ3eczRFL5k3BVTghnCXYsqI3yMu3H3SVN1DtrlLuSvyYEc4SMBqlsNDAT7w6lTPpGwdl5vp-H2szndAlCMRzmz0W95t7m5VeT56lcLdhT5VORB_KNB5IlreZrTO9OY2pFNYOyMaZ74b2pzRjYPG-FoRMuY1jXlYqOM8hTluf3MXvFNPTRbN47P0bKpnb0U6GT3w-UXsXgyVZPGm7THSKXBVuzcAiG9w5zHrsiQNiN0oDLjVUqSm8GI_ZTzQ6g-58hNU48OUcziCcsWMcAsodzh98W7RWGjgJov7fZVfjxKTqzNyiAtlpKft_-; _chartbeat2=.1590076934733.1607770749770.0000000000000001.Bv_jvLCsgxBgBrES30BYKLrsa451G.2; QSI_HistorySession=https%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%237ac9a205335d~1607770684517%7Chttps%3A%2F%2Fwww.forbes.com%2Fglobal2000%2F%23295aa3b7335d~1607770749825; _chartbeat4=t=qJcC1KrFWu5aWrqDdNx7QptOT4&E=5&x=0&c=0.16&y=11294&w=1010; session_depth=www.forbes.com%3D3%7C462705817%3D3%7C383070046%3D3%7C823003578%3D3%7C659093976%3D3%7C218291818%3D3; mnet_session_depth=3%7C1607770679072'
  )
  
  params = list(
    `limit` = '2000'
  )
  
  res <- httr::GET(url = paste0('https://www.forbes.com/forbesapi/org/global2000/',year_choice,'/position/true.json'), httr::add_headers(.headers=headers), query = params)
  
  df <- fromJSON(content(res, 'text'))
  
  findf <- data.table(df$organizationList$organizationsLists) %>% transmute(uri, industry, country, organization.image)
  
  return(findf)  
}

countries_industries <- get_forbes_extra_racing_data()

# Create analytics samples ------------------------------------------------

forbes_years_racingChart_data <- inner_join(forbes_years_racingChart_data, countries_industries, by = 'uri')

sample_companies_racing_chart <- forbes_years_racingChart_data[order(-forbes_years_racingChart_data$marketValue_2020),] %>% head(20)

random_sample_companies <- sample_n(forbes_years_racingChart_data, 20, replace = F)


# Write out data to load into Flourish ------------------------------------

write.csv(sample_companies_racing_chart, file = 'racing_chart_companies_assign2.csv')

write.csv(random_sample_companies, file = 'racing_chart_random_companies_assign2.csv')

write.csv(forbes_years_racingChart_data, file = 'all_companies_assign2.csv')
