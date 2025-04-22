#!/bin/sh
rm -f ./EHMI_testbed.zip
cd EHMI
zip -rq ../EHMI_testbed.zip .
cd ..
curl -F updateSpecification=true -F specification=81B858B9X7EA4X464CX9EAFX6F8BAF8A1E70 -F testSuite=@EHMI_testbed.zip --header "ITB_API_KEY: FC8EA8D5XEADBX47DCX85B3X524BC3799A78" -X POST http://localhost:9000/api/rest/testsuite/deploy
