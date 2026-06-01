# Take a snapshot of a shutdown machine

Run:
```
virsh snapshot-create-as --domain YourVMName --name "SnapshotName" --description "Snapshot Description"
```

# Take a snapshot of a running machine:

Run:
```
virsh snapshot-create-as --domain YourVMName --name "LiveSnapshotName" --description "Snapshot Description" --disk-only --atomic
```

# List all snapshots

Run:
```
virsh snapshot-list YourVMName
```

# Revert to a snapshot

Run:
```
virsh snapshot-revert --domain YourVMName --snapshotname "SnapshotName"
```

# Delete a snapshot

Run:
```
virsh snapshot-delete --domain YourVMName --snapshotname "SnapshotName"
```
