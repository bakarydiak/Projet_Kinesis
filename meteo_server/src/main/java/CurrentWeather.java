import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class CurrentWeather {
    @SerializedName("main")
    private Temperature temperature;

    @SerializedName("weather")
    private ArrayList<Weather> weather;

    @SerializedName("wind")
    private Wind wind;

    public Wind getWind() {
        return wind;
    }

    public void setWind(Wind wind) {
        this.wind = wind;
    }

    public ArrayList<Weather> getWeather() {
        return weather;
    }

    public void setWeather(ArrayList<Weather> weather) {
        this.weather = weather;
    }

    public Temperature getTemperatures() {
        return temperature;
    }

    public void setWeather(Temperature temperature) {
        this.temperature = temperature;
    }
}
