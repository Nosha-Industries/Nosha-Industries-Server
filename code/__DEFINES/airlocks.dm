// States for airlock_control
#define BULKHEAD_STATE_INOPEN "inopen"
#define BULKHEAD_STATE_PRESSURIZE "pressurize"
#define BULKHEAD_STATE_CLOSED "closed"
#define BULKHEAD_STATE_DEPRESSURIZE "depressurize"
#define BULKHEAD_STATE_OUTOPEN "outopen"
#define BULKHEAD_STATE_OPEN "open"

// States for airlock construction.
#define AIRLOCK_CONSTRUCTION_STATE_PLACED 3 // Default
#define AIRLOCK_CONSTRUCTION_STATE_WRENCHED 2
#define AIRLOCK_CONSTRUCTION_STATE_WIRED 1
#define AIRLOCK_CONSTRUCTION_STATE_BUILT 0
#define AIRLOCK_CONSTRUCTION_STATE_UNSCREWED -1
#define AIRLOCK_CONSTRUCTION_STATE_WIRECUT -2
#define AIRLOCK_CONSTRUCTION_STATE_UNWELDED -3
#define AIRLOCK_CONSTRUCTION_STATE_UNWRENCHED -4
