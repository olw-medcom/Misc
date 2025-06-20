#!/bin/sh
rm -f ./EHMI_testbed.zip
cd EHMI
zip -rq ../EHMI_testbed.zip .
cd ..
# specification API key comes Domain Management -> Choose Domain from list -> The spec from the list -> Api Key
# ITB_API_KEY comes from Community Management -> Choose community from list -> Api Key
curl -F updateSpecification=true -F specification=32FF9302XC0DAX4446X9E13X1D764116A5A6 -F testSuite=@EHMI_testbed.zip --header "ITB_API_KEY: FC8EA8D5XEADBX47DCX85B3X524BC3799A78" -X POST http://localhost:9000/api/rest/testsuite/deploy
