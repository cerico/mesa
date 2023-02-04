NPM_TOKEN=$(shell awk -F'=' '{print $$2}' ~/.npmrc)
COMMIT_FILE = COMMIT.md
generate:
	./bin/init.js
commit:
	code COMMIT.md
npm:
	@echo $(NPM_TOKEN) > npm
	gh secret set NPM_TOKEN < npm
	rm npm
ifneq ("$(wildcard $(COMMIT_FILE))","")
pr:
	git rebase origin/main
	git reset origin/main
	git add .
	git commit -F COMMIT.md
	git push -f
	gh pr create --fill
	rm COMMIT.md
else
pr:
	@echo run \"make commit\" to create conventional commits before creating PR
endif
gh:
	gh secret set GH_TOKEN < ~/.ssh/kawajevo/deploy_rsa
push:
	@git diff --quiet main.. package.json && echo 'Update package.json before pushing!' || git push -u origin HEAD
