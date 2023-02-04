NPM_TOKEN=$(shell awk -F'=' '{print $$2}' ~/.npmrc)
generate:
	./bin/init.js
npm:
	@echo $(NPM_TOKEN) > npm
	gh secret set NPM_TOKEN < npm
	rm npm
pr:
	git reset main
	git add .
	git commit -F commit
	gh pr create --fill
	echo > commit
gh:
	gh secret set GH_TOKEN < ~/.ssh/kawajevo/deploy_rsa
push:
	@git diff --quiet main.. package.json && echo 'Update package.json before pushing!' || git push -u origin HEAD
