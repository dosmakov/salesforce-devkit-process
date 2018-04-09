/**
* @author Denis Osmakov <denis@osmakov.me>
* @description Asynchronous process queue. 
*
*/
public without sharing class ProcessQueueable implements Queueable {
	// Singleton

	private static final ProcessQueueable INSTANCE = new ProcessQueueable();
	private ProcessQueueable() {}
	
	/**
	* @description Return instance of the Singleton class
	*/
	public static ProcessQueueable getInstance() {
		return INSTANCE;
	}

	/**
	* @description Queue of Asynchronous processes
	*/
    public Map<String, Process> Queue = new Map<String, Process>();
    

    /**
	* @description Execute processe in the Queue
	*/
    public void execute(QueueableContext context) {
        for (Process Process : Queue.values()) {
        	Process.Run();
     	}    
    }

	/**
    * @description Execute queued bussines logic asynchronous
    */
    @InvocableMethod(label='Run Async Processes' description='Run Async Processes')
    public static void RunAsyncProcesses() {
        ProcessQueueable AsyncJob = ProcessQueueable.getInstance();
        
        if (AsyncJob.Queue.isEmpty()) return;
        
        Id JobID = System.enqueueJob(AsyncJob);
        System.debug('Queued JobID: ' + JobID);
    }

}