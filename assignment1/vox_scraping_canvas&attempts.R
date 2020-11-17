library(rvest)
library(data.table)

# my_url_vox <- 'https://www.vox.com/search?q=trump'

get_one_page_from_vox <- function(my_url_vox) {
  
  t <- read_html(my_url_vox)
  
  boxes <- t %>%html_nodes('.c-entry-box--compact')
  
  box_dfs <- lapply(boxes, function(x){
    
    tl <- list()
    
    tl[['title']] <- x %>% html_nodes('.c-entry-box--compact__title') %>% html_text()
    tl[['author']] <- x %>% html_nodes('.c-byline__author-name') %>% html_text()
    tl[['timestamp']] <- x %>% html_nodes('time.c-byline__item') %>% html_attr('datetime') %>% strtrim(10) %>% as.Date()
    tl[['link']] <- x %>% html_nodes('.c-entry-box--compact__image-wrapper') %>% html_attr('href')
    
    return(tl)
    
  })
  
  df <- rbindlist(box_dfs, fill = T)
  return(df)
  
}

# example search term "ionel"
# example pages to download "5"

get_vox_data <- function(searchterm, pages_to_download) {
  # concatenate the search terms together according to URL
  searchterm <- gsub(' ','+',searchterm)
  # create links
  links_to_get <- 
    c(paste0('https://www.vox.com/search?order=date&q=',searchterm),paste0('https://www.vox.com/search?order=date&page=',2:pages_to_download,'&q=',searchterm))
  ret_df <- rbindlist(lapply(links_to_get, get_one_page_from_vox))
  return(ret_df)
  
}

kukus <- get_vox_data('trump biden',5) # algorithm cannot yet deal with multiple authors; it lists them as having written separate articles
