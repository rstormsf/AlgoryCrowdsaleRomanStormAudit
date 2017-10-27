export default function isEventTriggered(logs, eventName) {
    return logs.find(e => e.event === eventName);
}
