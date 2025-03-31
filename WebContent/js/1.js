console.log("JavaScript file loaded!");

document.addEventListener("DOMContentLoaded", function () {
    function updateClock() {
        const clockElement = document.getElementById("clock");

        if (!clockElement) {
            console.error("Clock element not found!");
            return;
        }

        const d = new Date();
        const date = d.toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
        const time = d.toLocaleTimeString();

        clockElement.innerHTML = date + " | " + time;
    }

    // Run immediately after DOM loads
    updateClock();
    // Update every second
    setInterval(updateClock, 1000);
});
