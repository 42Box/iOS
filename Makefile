gen:
	mise use tuist@3.36.2
	tuist fetch
	tuist generate

clean:
	tuist clean

fclean: clean
	find . -name "*.xcodeproj" -exec rm -rf {} \;
	find . -name "*.xcworkspace" -exec rm -rf {} \;

re: fclean gen

tf: 
	tuist signing decrypt
	tuist fetch
	tuist generate

	fastlane tf