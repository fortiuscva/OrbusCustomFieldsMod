permissionset 50100 CUSTFIELDSMODGenPerm
{
    Assignable = true;
    Permissions = tabledata IN_Queue=RIMD,
        tabledata OrbusLocations=RIMD,
        table IN_Queue=X,
        table OrbusLocations=X,
        page IN_Queue=X,
        page OrbusLocationsPage=X;
}
