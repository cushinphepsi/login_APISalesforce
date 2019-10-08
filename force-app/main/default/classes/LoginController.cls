public with sharing class LoginController {
    public TaiKhoan__c account{get;set;} //Assume it to be ur custom user

    public LoginController(){
        account = new TaiKhoan__c();  
    }

    public PageReference login(){
        if ( (account.TenDangNhap__c == null) || (account.MatKhau__c == null)){
            return null;
        }
        List<TaiKhoan__c> listAccount= [select Name,TenDangNhap__c,MatKhau__c from TaiKhoan__c];

        for(TaiKhoan__c acc : listAccount){
            if ((acc.TenDangNhap__c == account.TenDangNhap__c) && (acc.MatKhau__c == account.MatKhau__c)){
                PageReference page = new PageReference('/apex/WelcomePage');
                page.getParameters().put('accountId',acc.Name);
                page.setRedirect(true);
                return page;
            }
        }
        return null ;
    }

    public void welcome(){
        String accountId = ApexPages.currentPage().getParameters().get('accountId');
        if (String.isNotBlank(accountId)){
            account = [Select Name, TenDangNhap__c, MatKhau__c from TaiKhoan__c where Name = :accountId];
        }
    }

    public PageReference signUp(){
        insert account;
        Pagereference page = new Pagereference(ApexPages.currentPage().getUrl());
        page.setRedirect(true);
        return page;
    }

}
