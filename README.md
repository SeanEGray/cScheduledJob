# cScheduledJob
DSC Resource for creating and configuring Scheduled Jobs on Windows Server.
This module aims to implement most of the options made available by the PSScheduledJob module; the RunEvery and RunNow parameters for Register-ScheduledJob cannot be implemented, as they simply create triggers that can't be distinguished from triggers created with the Trigger parameter.

This module has not yet achieved minimal viable functionality. Do not use it, yet.


