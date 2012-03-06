#!/usr/bin/awk -f 
BEGIN {
   max_pid=0;
}
{
   event = $1;
   time = $2;
   packet_id = $12;
   
	packet_length[packet_id] = $6;
        flow_id[packet_id]=$9; 
   if ( packet_id > max_pid )
   {	
	 max_pid = packet_id;
   } 	
  	
   if ( (event != "d")&&(event != "r") ) 
   {
	if ( event == "+" ) 
	{
		t_Enqueue[packet_id] = time;
	}
	if ( event == "-" ) 
	{
		t_Dequeue[packet_id] = time;
		event_mode[packet_id]=1;
	}
   }
    if ( event == "d") 
    {
	event_mode[packet_id]=2;
    }	
         	
}
END {
  for ( packet_id = 0; packet_id <= max_pid + 1; packet_id++ )
  {
	if (event_mode[packet_id] ==1) 
        {
      		queue_delay =t_Dequeue[packet_id]-t_Enqueue[packet_id];
      		printf("%d %.6f %d %d %.6f %.6f  \n", packet_id, queue_delay, flow_id[packet_id], packet_length[packet_id],t_Dequeue[packet_id],t_Enqueue[packet_id]);
	}
	if (event_mode[packet_id] ==2) 
        {
		drop_mark=1000000;
		finish_mark=1;
		printf("%d %d %d %d %d %.6f \n", packet_id, drop_mark, flow_id[packet_id], packet_length				     [packet_id],finish_mark,t_Enqueue[packet_id]);
	}
		
  }
exit 0
}


