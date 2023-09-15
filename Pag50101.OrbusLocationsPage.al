page 50101 OrbusLocationsPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = OrbusLocations;
    Caption = 'Orbus Locations';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Location; rec.OrbusLocation)
                {
                    ApplicationArea = All;
                }
                field(State; rec.OrbusState)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                end;
            }
        }
    }
    var myInt: Integer;
}
