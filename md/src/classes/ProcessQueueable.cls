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
    public List<Process> Queue = new List<Process>();
    

    /**
	* @description Execute processe in the Queue
	*/
    public void execute(QueueableContext context) {
        for (Process Process : Queue) {
        	Process.Run();
     	}    
    }

}