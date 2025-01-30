#!/usr/bin/env bash

jmeter -Dsampleresult.default.encoding=UTF-8 -t ../src/test/jmeter/petclinic_test_plan.jmx &
