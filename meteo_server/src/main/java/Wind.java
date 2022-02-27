import com.google.gson.annotations.SerializedName;

public class Wind {

    @SerializedName("speed")
    private float speed;

    @SerializedName("deg")
    private int deg;

    public float getSpeed() {
        return speed;
    }

    public void setSpeed(float speed) {
        this.speed = speed;
    }

    public int getDeg() {
        return deg;
    }

    public void setDeg(int deg) {
        this.deg = deg;
    }
}
