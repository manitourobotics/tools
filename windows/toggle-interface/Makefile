ver = 1.2
name = toggle-interface
zip_filename=$(name)-$(ver)

zip:
	echo $(zip_filename)
	mkdir $(zip_filename)/
	cp config.example.txt how-to-setup.txt run-toggle-interface.bat toggle-interface.py $(zip_filename)/
	zip -r $(zip_filename).zip $(zip_filename)/
	rm -r $(zip_filename)
clean:
	rm *.zip
