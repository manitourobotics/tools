ver = 1
name = interface-information
zip_filename=$(name)-$(ver)

zip:
	echo $(zip_filename)
	mkdir $(zip_filename)/
	cp config.example.txt how-to-setup.txt interface-information.py $(zip_filename)/
	zip -r $(zip_filename).zip $(zip_filename)/
	rm -r $(zip_filename)
clean:
	rm *.zip
