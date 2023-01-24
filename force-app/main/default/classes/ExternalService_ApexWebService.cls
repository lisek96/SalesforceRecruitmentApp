public with sharing class ExternalService_ApexWebService {

    private ExternalService.RWSApexWebService rwsApexWebService = new ExternalService.RWSApexWebService();

    private ExternalService.RWSApexWebService.getServicesApexrestApexWebService_Request findAccountRequest =
            new ExternalService.RWSApexWebService.getServicesApexrestApexWebService_Request();
    private ExternalService.RWSApexWebService.postServicesApexrestApexWebService_Request createAccountRequest =
            new ExternalService.RWSApexWebService.postServicesApexrestApexWebService_Request();

    private FindAccountResponse findAccountResponse = new FindAccountResponse();
    private CreateAccountResponse createAccountResponse = new CreateAccountResponse();

    public ExternalService_ApexWebService(){
        this.createAccountRequest.accountInfo = new ExternalService.RWSApexWebService_AccountInfoWrapper();
    }

    private class FindAccountResponse{
        ExternalService.RWSApexWebService.getServicesApexrestApexWebService_Response successResponse;
        ExternalService.RWSApexWebService.getServicesApexrestApexWebService_ResponseException failResponse;
    }

    private class CreateAccountResponse{
        ExternalService.RWSApexWebService.postServicesApexrestApexWebService_Response successResponse;
        ExternalService.RWSApexWebService.postServicesApexrestApexWebService_ResponseException failResponse;
    }

    public ExternalService_ApexWebService setFindAccountRequestAccountName(String accName){
        findAccountRequest.accountName = accName;
        return this;
    }

    public ExternalService_ApexWebService setCreateAccountRequestAccountName(String accName){
        createAccountRequest.accountInfo.accName = accName;
        return this;
    }

    public ExternalService_ApexWebService setCreateAccountRequestBillingCountry(String billingCountry){
        createAccountRequest.accountInfo.billingCountry = billingCountry;
        return this;
    }

    public ExternalService_ApexWebService findAccount(){
        try{
            findAccountResponse.successResponse = rwsApexWebService.getServicesApexrestApexWebService(findAccountRequest);
        }catch (ExternalService.RWSApexWebService.getServicesApexrestApexWebService_ResponseException exc){
            findAccountResponse.failResponse = exc;
        }
        return this;
    }

    public ExternalService_ApexWebService createAccount(){
        try {
            createAccountResponse.successResponse = rwsApexWebService.postServicesApexrestApexWebService(createAccountRequest);
        }catch (ExternalService.RWSApexWebService.postServicesApexrestApexWebService_ResponseException exc){
            createAccountResponse.failResponse = exc;
        }
        return this;
    }

    public ExternalService_ApexWebService debugFindAccountResponse(){
        System.debug(FindAccountResponse);
        return this;
    }

    public ExternalService_ApexWebService debugCreateAccountResponse(){
        System.debug(CreateAccountResponse);
        return this;
    }

    public static void sampleRun(){
        ExternalService_ApexWebService apexWebService = new ExternalService_ApexWebService();

        apexWebService
                .setFindAccountRequestAccountName('Britenet')
                .findAccount()
                .debugFindAccountResponse()
                .setCreateAccountRequestAccountName('Britenet sp zoo')
                .setCreateAccountRequestBillingCountry('Poland')
                .createAccount()
                .debugCreateAccountResponse();
    }
}