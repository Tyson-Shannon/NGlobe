=begin
**RUN AS SUDO**
NGlobal runs NMap scans on a list of websites
and writes to a txt file any sites that meet
vulnerability criteria in the vuln list

by Tyson Shannon
=end

require 'uri'

file_path = "websites.txt" #replace--------------!

#empty output
File.write("output.txt", "")
#retrieve target sites
sites = File.readlines(file_path)
#list of vulnerabilities/basic vulnerability indicators (default)
vuln = ["VULNERABLE", "CVE"]

#nmap over list of sites
for site in sites do
  #get host name
  if site.include?("http")
    clean_site = site.delete("\n")
    uri_site = URI(clean_site)
    host = uri_site.host
  else
    host = site
  end
  #nmap the hostname
  cmd = `sudo nmap --script vuln #{host}`
  #check if site meets vulnerability criteria
  if vuln.any? { |v| cmd.include?(v) }
    #write vulnerable sites to output
    File.write("output.txt", site+"\n", mode: "a")
  end
end