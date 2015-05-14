#!/usr/bin/env bats

load helpers

export DRIVER=sdc
export NAME="bats-$DRIVER-test"
export MACHINE_STORAGE_PATH=/tmp/machine-bats-test-$DRIVER

@test "$DRIVER: machine should not exist" {
  run machine active $NAME
  [ "$status" -eq 1  ]
}

@test "$DRIVER: create" {
  run machine create -d $DRIVER --sdc-account $NAME $NAME
  [ "$status" -eq 0  ]
}

@test "$DRIVER: active" {
  run machine active $NAME
  [ "$status" -eq 0  ]
}

@test "$DRIVER: ls" {
  run machine ls
  [ "$status" -eq 0  ]
  [[ ${lines[1]} == *"$NAME"*  ]]
  [[ ${lines[1]} == *"*"*  ]]
}

@test "$DRIVER: run busybox container" {
  run docker $(machine config $NAME) run --rm busybox echo hello world
  [ "$status" -eq 0  ]
}

@test "$DRIVER: url" {
  run machine url $NAME
  [ "$status" -eq 0  ]
}

@test "$DRIVER: ip" {
  run machine ip $NAME
  [ "$status" -eq 0  ]
}

@test "$DRIVER: ssh should fail (unsupported)" {
  run machine ssh $NAME -- ls -lah /
  [[ ${lines[1]} == *"not avaiable"*  ]]
}

@test "$DRIVER: stop should fail (unsupported)" {
  run machine stop $NAME
  [[ ${lines[1]} == *"not avaiable"*  ]]
}

@test "$DRIVER: start should fail (unsupported)" {
  run machine start $NAME
  [[ ${lines[1]} == *"not avaiable"*  ]]
}

@test "$DRIVER: restart should fail (unsupported)" {
  run machine restart $NAME
  [[ ${lines[1]} == *"not avaiable"*  ]]
}

@test "$DRIVER: machine should show running" {
  run machine ls
  [ "$status" -eq 0  ]
  [[ ${lines[1]} == *"Running"*  ]]
}

@test "$DRIVER: remove" {
  run machine rm $NAME
  [ "$status" -eq 0  ]
}

@test "$DRIVER: machine should not exist" {
  run machine active $NAME
  [ "$status" -eq 1  ]
}

@test "$DRIVER: cleanup" {
  run rm -rf $MACHINE_STORAGE_PATH
  [ "$status" -eq 0  ]
}
