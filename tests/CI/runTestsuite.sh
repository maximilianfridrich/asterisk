#!/usr/bin/env bash
CIDIR=$(dirname $(readlink -fn $0))
source $CIDIR/ci.functions
ASTETCDIR=$DESTDIR/etc/asterisk

pushd $TESTSUITE_DIR

runner sudo PYTHONPATH=./lib/python/ ./runtests.py --cleanup ${TEST_COMMAND} || :

if [ -f asterisk-test-suite-report.xml ]  ; then
	sudo chown jenkins:users asterisk-test-suite-report.xml
fi

runner ${CIDIR}/fixTestResults.py asterisk-test-suite-report.xml asterisk-test-suite-report.xml

if [ -f core* ] ; then
	echo "*** Found a core file after running unit tests ***"
	sudo /var/lib/asterisk/scripts/ast_coredumper --no-default-search core*
	exit 1
fi

popd