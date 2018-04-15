public class docappcontroller {

 public List <Time> timelist{get;set;}
 public List <Wrapertimeslot> timewraplist{get;set;}
 public List <Wrapertimeslot> timewraplistInitial=new List <Wrapertimeslot> ();
 Public integer Initialselected=0;
 public set<time> timeset;



 public String Dobooking() {
    integer counter=0;
    For(Wrapertimeslot wt:timewraplist){
        if(wt.selected){
            counter++;
        }


    }
    if(counter == Initialselected+1){
        Appointment__c a=new Appointment__c();
        for(Wrapertimeslot wt: timewraplist){
            if(wt.selected)
            if(!timeset.contains(wt.t)){

                a.Start_Time__c=wt.t;
            }
        }
        System.debug(a);

        
        if(!timeset.contains(a.Start_Time__c.addMinutes(SelectedtimeSlot-30))){
        a.End_Time__c=a.Start_Time__c.addMinutes(SelectedtimeSlot);
    

        a.Patient__c=aptdum.Patient__c;
        a.doctor__c=Selecteddoc;
        a.Appointment_Date__c=aptdum.Appointment_Date__c;
        System.debug(a);

        insert a;
        ApexPages.Message m = new ApexPages.message(ApexPages.severity.INFO,'The Appointment is created');
             ApexPages.addMessage(m);
             fetchslots();
        }else{

            fetchslots();
        ShowError('Slot clash with next appointment');
        }


    }else{
        fetchslots();
        ShowError('Select only one time');

    }


return null;
 }

    public String fetchslots() {
    
        system.debug(Selecteddoc);
        
        
        if(Docmap.containskey(Selecteddoc)){
            doctor__c d=Docmap.get(Selecteddoc);
            list<Appointment__c> aptlist= new list<Appointment__c>([SELECT Id, Name, Doctor__c, Patient__c, End_Time__c, Start_Time__c FROM Appointment__c where Doctor__c =:Selecteddoc and Appointment_Date__c=:aptdum.Appointment_Date__c]);
            timeset= new set<time>();
            for(Appointment__c apt: aptlist){
            
            time t=apt.Start_Time__c;
            integer i=apt.End_Time__c.hour() - apt.Start_Time__c.hour();
            decimal i1=0;
            timeset.add(t);
            do {
                System.debug(t);
                t=t.addMinutes(30);
                i1=i1+0.5;
                timeset.add(t);
            } while (i1<(i-0.5));
            
            }
            //d.Start_Time__c ;
            //d.End_Time__c;
            
           // for(time t=d.Start_Time__c ;d.Start_Time__c< d.End_Time__c;d.Start_Time__c.addMinutes(30)){
            
            //system.debug(t);
            //}
            
            timewraplist =new List <Wrapertimeslot>();
            timelist= new list<Time>();
            time t=d.Start_Time__c;
            integer i=d.End_Time__c.hour() - d.Start_Time__c.hour();
            decimal i1=0;
            if(!timeset.contains(t)){
            timewraplist.add(new Wrapertimeslot(false,t));
            }else{
            timewraplist.add(new Wrapertimeslot(true,t));
            Initialselected++;
            }
            timelist.add(t);
            

            while (i1<i) {
                System.debug(t);
                t=t.addMinutes(30);
                i1=i1+0.5;
                timelist.add(t);
                
                if(!timeset.contains(t)){
            timewraplist.add(new Wrapertimeslot(false,t));
            }else{
            timewraplist.add(new Wrapertimeslot(true,t));
            Initialselected++;
                        }
                
                
                
                
            } while (i1<(i-0.5));
            
            
        
        }
        
        timewraplistInitial=timewraplist;
    
        return null;
    }


   


Public Doctor__c Docdum{get;set;}
Public Appointment__c aptdum{get;set;}
Public map<id,Doctor__c> Docmap{get;set;}
Public String Selecteddoc{get;set;}
Public Integer SelectedtimeSlot{get;set;}
Public list<doctor__C> docnameList{get;set;}

Public docappcontroller(){
        Docdum=new Doctor__c();
        aptdum=new Appointment__c();
    }
    
 public String getGetdoc() {
 system.debug('hello--->'+Docdum);
     if(Docdum.Speciality__c!= null){
     Docmap=new map<id,Doctor__c>([SELECT Id,Name, End_Time__c, Speciality__c, Start_Time__c FROM Doctor__c where Speciality__c=:Docdum.Speciality__c]);
     
     }
 system.debug(Docmap);
 
 
 return null;
    }
    
    //Public List<SelectOption> getdocNameValues(){}
    
    Public List<SelectOption> getdocNameValues(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        If(Docmap!=null ){
            for (doctor__C doc:docmap.values() ){
                options.add(new SelectOption(doc.id,doc.Name));
            }
        }else{
            ShowError('No Continents Data yet.');
        }
        
        return options;
    }
    


Public List<SelectOption> getTimeInterval(){
        
        List<SelectOption> options = new List<SelectOption>();
        Time_Interval__mdt [] intervals = [SELECT Interval__c FROM Time_Interval__mdt order by Interval__c];
        //options.add(new SelectOption('','--None--'));

        for(Time_Interval__mdt i:intervals){
            options.add(new SelectOption(i.Interval__c,i.Interval__c));
        }
        //options.add(new SelectOption('30','30'));
        //options.add(new SelectOption('60','60'));

          
        
        
        return options;
    }



    
  Public void ShowError(string ErrorMsg){
    
        ApexPages.Message m = new ApexPages.message(ApexPages.severity.ERROR,ErrorMsg);
        ApexPages.addMessage(m);    
    }  
    
   public class Wrapertimeslot{
        Public Boolean selected{get; set;}
        Public time t{get; set;}
        
        public Wrapertimeslot(boolean selection, time tm){
        selected = selection;
        t=tm;
        
        }
    
    } 


}