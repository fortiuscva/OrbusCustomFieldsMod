enum 50101 OrderStatus
{
    Extensible = true;

    value(0; Draft)
    {
    Caption = 'Draft';
    }
    value(1; ReadyForProduction)
    {
    Caption = 'Ready for Production';
    }
    value(2; ReadyForArt)
    {
    Caption = 'Ready for Art';
    }
    value(3; InArtCoordination)
    {
    Caption = 'In Art Coordination';
    }
    value(4; "ReadyforPick/Release")
    {
    Caption = 'Ready for Pick & Release';
    }
    value(5; "Pick Released")
    {
    Caption = 'Pick Released';
    }
    value(6; "AC In Production")
    {
    Caption = 'AC In Production';
    }
    value(7; "In Production")
    {
    Caption = 'In Production';
    }
    value(8; "AC Hold")
    {
    Caption = 'AC Hold';
    }
    value(9; "PM Ready For Production")
    {
    Caption = 'PM Ready For Production';
    }
    value(10; "PM Hold")
    {
    Caption = 'PM Hold';
    }
    value(11; Storage)
    {
    Caption = 'Storage';
    }
    value(12; "Pending Back Order")
    {
    Caption = 'Pending Back Order';
    }
    value(13; "Planning Hold")
    {
    Caption = 'Planning Hold';
    }
}
