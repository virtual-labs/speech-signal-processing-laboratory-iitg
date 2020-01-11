build-dir=../build

all:patch-analytics help-dir

help-dir:
	(mkdir -p ${build-dir}; rsync -avC * ${build-dir})

patch-analytics:
	git clone https://github.com/virtual-labs/vlabs-analytics.git
	cp vlabs-analytics/gtm-patcher.py ../scripts/.
	cp vlabs-analytics/patch-analytics.sh ../scripts/.
	chmod +x ../scripts/patch-analytics.sh 
	../scripts/patch-analytics.sh
	rm -rf vlabs-analytics
	rm -rf ../scripts/patch-analytics.sh
	rm -rf ../scripts/gtm-patcher.py

















