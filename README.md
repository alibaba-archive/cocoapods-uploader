# cocoapods-uploader
cocoapods-uploader is a tool that help upload file/dir to remote repository.


## Installation

		$ gem install cocoapods-uploader
		
## Usage

- setting

		$ pod upload maven set HOST REPO [USER] [PASSWORD] [SUFFIX]
		
	etc:
	
		$ pod upload maven set http://mvn.xxxx.com test sanping.li xxx /artifactory/service/local/repositories/+repo+/content/
		

- upload 

		$ pod upload maven PATH SPEC
		
	etc:
	
		$ pod upload maven ios Test.podspec
		
		
## Author

[https://github.com/supern](https://github.com/supern)
