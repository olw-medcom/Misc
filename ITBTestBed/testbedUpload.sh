#!/bin/sh
rm -f ./EHMI_testbed.zip
cd EHMI
zip -rq ../EHMI_testbed.zip .
cd ..
# you need to enable API Key management. Go to System administration -> Unfold REST API -> Enable checkbox
# specification API key comes Domain Management -> Choose Domain from list -> The spec from the list -> Api Key
# ITB_API_KEY comes from Community Management -> Choose community from list -> Api Key
curl -F updateSpecification=true -F specification=436FE513X22D3X49B6X8603X31FDBE957619 -F testSuite=@EHMI_testbed.zip --header "ITB_API_KEY: D3E24F26X734DX40B6XA886XDA1E6B48C566" -X POST http://localhost:9000/api/rest/testsuite/deploy
