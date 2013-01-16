ver=1
zip_name= revive-smart-dashboard-$(ver).zip

install:
	cp monitor.py ../../../monitor.py

package:
	zip $(zip_name) monitor.py py_service.py

clean: 
	rm $(zip_name)
   
