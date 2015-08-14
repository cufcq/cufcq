pkill -f solr 
 
#remove old data 
rm -rf solr/data 
rm -rf solr/default 
rm -rf solr/development 
rm -rf solr/pids 
rm -rf solr/test 
 
while getopts 'pdt' flag; do 
  case "${flag}" in 
    d) export RAILS_ENV=development ;; 
    p) export RAILS_ENV=production ;; 
    t) export RAILS_ENV=test ;; 
    *) error "Unexpected option ${flag}" ;; 
  esac 
done 

#startup solr 
bundle exec rake sunspot:solr:start 
